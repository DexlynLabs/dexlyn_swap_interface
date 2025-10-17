module dexlyn_clmm::pool {
    use std::option::Option;
    use std::string::String;

    use supra_framework::fungible_asset::FungibleAsset;

    use integer_mate::i128::I128;
    use integer_mate::i64::I64;

    friend dexlyn_clmm::factory;

    struct PoolDetails has drop {
        /// Pool index
        index: u64,

        /// Pool address
        pool_address: address,

        /// pool position token collection name
        collection_name: String,

        /// The pool asset A type
        asset_a: u64,

        /// The pool asset B type
        asset_b: u64,

        /// The tick spacing
        tick_spacing: u64,

        /// The numerator of fee rate, the denominator is 1_000_000.
        fee_rate: u64,

        /// The liquidity of current tick index
        liquidity: u128,

        /// The current sqrt price
        current_sqrt_price: u128,

        /// The current tick index
        current_tick_index: I64,

        /// The global fee growth of asset a as Q64.64
        fee_growth_global_a: u128,
        /// The global fee growth of asset b as Q64.64
        fee_growth_global_b: u128,

        /// The amounts of asset a owed to protocol
        fee_protocol_asset_a: u64,
        /// The amounts of asset b owed to protocol
        fee_protocol_asset_b: u64,

        /// Position Count
        position_count: u64,

        /// is the pool paused
        is_pause: bool,

        /// The position nft uri.
        uri: String,

        /// FungibleAsset A object address
        asset_a_addr: address,

        /// FungibleAsset B object address
        asset_b_addr: address,
    }


    /// The clmmpool's tick item
    struct Tick has copy, drop, store {
        index: I64,
        sqrt_price: u128,
        liquidity_net: I128,
        liquidity_gross: u128,
        fee_growth_outside_a: u128,
        fee_growth_outside_b: u128,
        rewarders_growth_outside: vector<u128>,
    }

    /// The clmmpool's liquidity position.
    struct Position has copy, drop, store {
        pool: address,
        index: u64,
        liquidity: u128,
        tick_lower_index: I64,
        tick_upper_index: I64,
        fee_growth_inside_a: u128,
        fee_owed_a: u64,
        fee_growth_inside_b: u128,
        fee_owed_b: u64,
        rewarder_infos: vector<PositionRewarder>,
    }

    /// The PositionRewarder for record position's additional liquidity incentives.
    struct PositionRewarder has drop, copy, store {
        growth_inside: u128,
        amount_owed: u64,
    }

    /// Flash loan resource for swap.
    /// There is no way in Move to pass calldata and make dynamic calls, but a resource can be used for this purpose.
    /// To make the execution into a single transaction, the flash loan function must return a resource
    /// that cannot be copied, cannot be saved, cannot be dropped, or cloned.
    struct FlashSwapReceipt {
        pool_address: address,
        a2b: bool,
        partner_name: String,
        pay_amount: u64,
        ref_fee_amount: u64
    }

    /// Flash loan resource for add_liquidity
    struct AddLiquidityReceipt {
        pool_address: address,
        amount_a: u64,
        amount_b: u64
    }

    /// The calculated swap result
    struct CalculatedSwapResult has copy, drop, store {
        amount_in: u64,
        amount_out: u64,
        fee_amount: u64,
        fee_rate: u64,
        after_sqrt_price: u128,
        is_exceed: bool,
        step_results: vector<SwapStepResult>
    }

    /// The step swap result
    struct SwapStepResult has copy, drop, store {
        current_sqrt_price: u128,
        target_sqrt_price: u128,
        current_liquidity: u128,
        amount_in: u64,
        amount_out: u64,
        fee_amount: u64,
        remainer_amount: u64
    }

    /// The position's fee result
    struct PositionReward has drop {
        pool_address: address,
        position_id: u64,
        fee_a: u64,
        fee_b: u64,
    }

    /// Open a position
    /// params
    ///     - account The position owner
    ///     - pool_address The pool account address
    ///     - tick_lower_index The position tick lower index
    ///     - tick_upper_index The position tick upper index
    /// returns
    ///     position_index: u64
    native public fun open_position(
        account: &signer,
        pool_address: address,
        tick_lower_index: I64,
        tick_upper_index: I64,
    ): u64;

    /// Add liquidity on a position by liquidity amount.
    /// anyone can add liquidity on any position, please check the ownership of the position befor call it.
    /// params
    ///     pool_address The pool account address
    ///     liqudity The delta liqudity amount
    ///     position_index The position index
    /// return
    ///     receipt The add liquidity receipt(hot-potato)
    native public fun add_liquidity(
        pool_address: address,
        liquidity: u128,
        position_index: u64
    ): AddLiquidityReceipt;

    /// Add liquidity on a position by asset amount.
    /// anyone can add liquidity on any position, please check the ownership of the position befor call it.
    /// params
    ///     pool_address The pool account address
    ///     amount The asset amount
    ///     fix_amount_a If true the amount is asset_a else is asset_b
    ///     position_index The position index
    /// return
    ///     receipt The add liquidity receipt(hot-potato)
    native public fun add_liquidity_fix_asset(
        pool_address: address,
        amount: u64,
        fix_amount_a: bool,
        position_index: u64
    ): AddLiquidityReceipt;


    /// Repay asset for increased liquidity
    /// params
    ///     asset_a The asset a
    ///     asset_b The asset b
    ///     receipt The add liquidity receipt(hot-patato)
    native public fun repay_add_liquidity(
        asset_a: FungibleAsset,
        asset_b: FungibleAsset,
        receipt: AddLiquidityReceipt
    );


    /// Remove liquidity from pool
    /// params
    ///     - account The position owner
    ///     - pool_address The pool account address
    ///     - position_index The position index
    /// return
    ///     - asset_a The asset a sended to user
    ///     - asset_b The asset b sended to user
    native public fun remove_liquidity(
        account: &signer,
        pool_address: address,
        liquidity: u128,
        position_index: u64
    ): (FungibleAsset, FungibleAsset);

    /// Close the position with check
    /// params
    ///     - account The position owner
    ///     - pool_address The pool account address
    ///     - position_index The position index
    /// return
    ///     - is_closed
    native public fun checked_close_position(
        account: &signer,
        pool_address: address,
        position_index: u64
    ): bool;

    /// Collect position's liquidity fee
    /// Params
    ///     - account The position's owner
    ///     - pool_address The address of pool
    ///     - position_index The position index
    ///     - recalculate If recalcuate the position's fee before collect.
    /// Return
    ///     - asset_a The position's fee of asset_a
    ///     - asset_b The position's fee of asset_b
    native public fun collect_fee(
        account: &signer,
        pool_address: address,
        position_index: u64,
        recalculate: bool,
    ): (FungibleAsset, FungibleAsset);

    /// Collect position's reward
    /// Params
    ///     - account The position's owner
    ///     - pool_address The address of pool
    ///     - position_index The position index
    ///     - rewarder_index The rewarder index
    ///     - recalculate If recalcuate the position's fee before collect.
    /// Return
    ///     - asset The reward asset
    native public fun collect_rewarder(
        account: &signer,
        pool_address: address,
        position_index: u64,
        rewarder_index: u8,
        recalculate: bool,
        asset_addr: address
    ): FungibleAsset;


    /// Swap output asset and flash loan resource.
    /// Params
    ///     - pool_address The address of pool
    ///     - swap_from The swap from address for record swap event
    ///     - partner_name The name of partner
    ///     - a2b The swap direction
    ///     - by_amount_in Express swap by amount in or amount out
    ///     - amount if by_amount_in is true it mean input amount else it mean output amount.
    ///     - sqrt_price_limit After swap the limit of pool's current sqrt price
    /// Returns
    ///     - asset_a The output of asset a, if a2b is true it zero
    ///     - asset_b The output of asset b, if a2b is false it zero
    ///     - receipt The flash loan resource
    native public fun flash_swap(
        pool_address: address,
        swap_from: address,
        partner_name: String,
        a2b: bool,
        by_amount_in: bool,
        amount: u64,
        sqrt_price_limit: u128,
    ): (FungibleAsset, FungibleAsset, FlashSwapReceipt);

    /// Repay for flash swap
    /// params
    ///     asset_a The asset a
    ///     asset_b The asset b
    /// returns
    ///     null
    native public fun repay_flash_swap(
        asset_a: FungibleAsset,
        asset_b: FungibleAsset,
        receipt: FlashSwapReceipt
    );

    /// Deposit reward tokens into a rewarder
    /// Params
    ///     - account The account depositing the reward tokens
    ///     - pool_address The address of pool
    ///     - rewarder_index: rewarder index
    ///     - rewarder_addr: The address of reward asset
    ///     - amount: The amount to deposit as rewards
    native public fun deposit_reward(
        account: &signer,
        pool_address: address,
        rewarder_index: u8,
        rewarder_addr: address,
        amount: u64
    );


    // VIEW AND GETTER FUNCTIONS
    //============================================================================================================
    /// Fetch a list of ticks from the pool.
    /// pool_address - Pool address.
    /// index - Starting index.
    /// offset - Offset from starting index.
    /// limit - Number of ticks to fetch.
    /// Returns tuple of (start index, end index, vector of Tick).
    native public fun fetch_ticks(
        pool_address: address, index: u64, offset: u64, limit: u64
    ): (u64, u64, vector<Tick>);


    /// Fetch a list of positions from the pool.
    /// pool_address - Pool address.
    /// index - Starting index.
    /// limit - Number of positions to fetch.
    /// Returns tuple of (start index, vector of Position).
    native public fun fetch_positions(
        pool_address: address, index: u64, limit: u64
    ): (u64, vector<Position>);


    #[view]
    /// Calculate the swap result.
    /// Params
    ///     - pool_address The address of pool
    ///     - a2b The swap direction
    ///     - by_amount_in Express swap by amount in or amount out
    ///     - amount if by_amount_in is true it mean input amount else it mean output amount.
    /// Returns
    ///     - swap_result The swap result
    native public fun calculate_swap_result(
        pool_address: address,
        a2b: bool,
        by_amount_in: bool,
        amount: u64,
    ): CalculatedSwapResult;

    /// Get the amount paid for a swap from the flash swap receipt.
    /// receipt - Reference to FlashSwapReceipt.
    /// Returns the pay amount as `u64`.
    native public fun swap_pay_amount(receipt: &FlashSwapReceipt): u64;

    /// Get the add liquidity receipt pay amounts.
    /// params
    ///     receipt
    /// return
    ///     amount_a The amount of asset a
    ///     amount_b The amount of asset b
    native public fun add_liqudity_pay_amount(
        receipt: &AddLiquidityReceipt
    ): (u64, u64);

    #[view]
    /// Get the tick spacing for a pool.
    /// pool - Pool address.
    /// Returns tick spacing as `u64`.
    native public fun get_tick_spacing(pool: address): u64;

    #[view]
    /// Get the current liquidity for a pool.
    /// pool - Pool address.
    /// Returns liquidity as `u128`.
    native public fun get_pool_liquidity(pool: address): u128;

    #[view]
    /// Get the index of a pool.
    /// pool - Pool address.
    /// Returns pool index as `u64`.
    native public fun get_pool_index(pool: address): u64;

    #[view]
    /// Get multiple positions by their indices.
    /// pool_address - Pool address.
    /// pos_indices - Vector of position indices.
    /// Returns vector of Position.
    native public fun get_positions(
        pool_address: address,
        pos_indices: vector<u64>
    ): vector<Position>;

    #[view]
    /// Get the tick range for a position by pool address.
    /// pool_address - Pool address.
    /// position_index - Position index.
    /// Returns tuple of (tick_lower, tick_upper).
    native public fun get_position_tick_range(
        pool_address: address,
        position_index: u64
    ): (I64, I64);

    #[view]
    /// Get the number of rewarders in a pool.
    /// pool_address - Pool address.
    /// Returns number of rewarders as `u8`.
    native public fun get_rewarder_len(pool_address: address): u8;

    #[view]
    /// Calculate fees for multiple positions in a pool.
    /// pool_address - Pool address.
    /// position_indices - Vector of position indices.
    /// Returns vector of PositionReward.
    native public fun calculate_positions_fees(
        pool_address: address,
        position_indices: vector<u64>,
    ): vector<PositionReward>;

    #[view]
    /// Get the asset addresses for a pool.
    /// pool_address - Pool address.
    /// Returns tuple of (asset_a_addr, asset_b_addr).
    native public fun get_pool_assets(pool_address: address): (address, address);

    #[view]
    /// Check if pools exist for a list of addresses.
    /// pool_addresses - Vector of pool addresses.
    /// Returns vector of bool indicating existence.
    native public fun is_pool_exists(pool_addresses: vector<address>): vector<bool>;

    #[view]
    /// Generate token addresses for a list of position IDs in a pool.
    /// pool_address - Pool address.
    /// position_ids - Vector of position IDs.
    /// Returns vector of token addresses.
    native public fun generate_token_addresses(pool_address: address, position_ids: vector<u64>): vector<address>;

    #[view]
    ///  Get best swap route across multiple pools with more precise control.
    /// pool_addresses - Vector of pool addresses.
    /// a2b - Swap direction.
    /// fix_amount_in - If true, amount is input amount; if false, amount is output amount.
    /// fix_amount_out - If true, amount is output amount; if false, amount is input amount.
    /// amount - Amount for swap.
    /// Returns tuple of (final pool address, CalculatedSwapResult).
    native public fun swap_routing(
        pool_addresses: vector<address>,
        a2b: bool,
        fix_amount_in: bool,
        fix_amount_out: bool,
        amount: u64
    ): (address, CalculatedSwapResult);

    #[view]
    /// Calculate swap results for multiple pools.
    /// pool_addresses - Vector of pool addresses.
    /// a2b - Swap direction.
    /// by_amount_in - Express swap by amount in or out.
    /// amount - Amount for swap.
    /// Returns vector of CalculatedSwapResult for each pool.
    native public fun calculate_all_pools_swap_results(
        pool_addresses: vector<address>,
        a2b: bool,
        by_amount_in: bool,
        amount: u64
    ): vector<CalculatedSwapResult>;


    #[view]
    /// Get detailed information for multiple pools.
    /// pool_addresses - Optional vector of pool addresses. If None, fetch details for all pools.
    /// Returns vector of optional Pooldetails (None if pool doesn't exist).
    native public fun get_pool_details(
        pool_addresses: vector<address>
    ): vector<Option<PoolDetails>>;
}
