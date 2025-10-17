module dexlyn_clmm::clmm_router {
    use std::string::String;

    /// Create a pool of clmmpool protocol. The pool is identified by (CoinTypeA, CoinTypeB, tick_spacing).
    /// Params
    ///     - tick_spacing
    ///     - initialize_sqrt_price: the init sqrt price of the pool.
    ///     - uri: this uri is used for token uri of the position token of this pool.
    ///     - asset_a_addr: FungibleAsset A address
    ///     - asset_b_addr: FungibleAsset B address
    /// Returns
    native public entry fun create_pool(
        account: &signer,
        tick_spacing: u64,
        initialize_sqrt_price: u128,
        uri: String,
        asset_a_addr: address,
        asset_b_addr: address,
    );

    /// Create a pool of clmmpool protocol. The pool is identified by (CoinTypeA, CoinTypeB, tick_spacing).
    /// Params
    ///     Type:
    ///         - CoinTypeA
    ///         - CoinTypeB
    ///     - tick_spacing
    ///     - initialize_sqrt_price: the init sqrt price of the pool.
    ///     - uri: this uri is used for token uri of the position token of this pool.
    ///     - asset_a_addr: FungibleAsset A address
    ///     - asset_b_addr: FungibleAsset B address
    /// Returns
    native public entry fun create_pool_coin_coin<CoinTypeA, CoinTypeB>(
        account: &signer,
        tick_spacing: u64,
        initialize_sqrt_price: u128,
        uri: String,
        asset_a_addr: address,
        asset_b_addr: address
    );

    /// Create a pool of clmmpool protocol. The pool is identified by (CoinType, FungibleAssetB, tick_spacing).
    /// Params
    ///     Type:
    ///         - CoinType
    ///     - tick_spacing
    ///     - initialize_sqrt_price: the init sqrt price of the pool.
    ///     - uri: this uri is used for token uri of the position token of this pool.
    ///     - asset_a_addr: FungibleAsset A address
    ///     - asset_b_addr: FungibleAsset B address
    /// Returns
    native public entry fun create_pool_coin_asset<CoinType>(
        account: &signer,
        tick_spacing: u64,
        initialize_sqrt_price: u128,
        uri: String,
        asset_a_addr: address,
        asset_b_addr: address
    );

    /// Add liquidity into a pool with Coins. The position is identified by the name.
    /// The position token is identified by (creator, collection, name), the creator is pool address.
    /// Params
    ///     - pool_address
    ///     - delta_liquidity
    ///     - max_amount_a: the max number of asset_a can be consumed by the pool.
    ///     - max_amount_b: the max number of asset_b can be consumed by the pool.
    ///     - tick_lower
    ///     - tick_upper
    ///     - open_new_position: control whether or not to create a new position or add liquidity on existed position.
    ///     - index: position index. if `open_new_position` is true, index is no use.
    /// Returns
    native public entry fun add_liquidity_coin_coin<CoinTypeA, CoinTypeB>(
        account: &signer,
        pool_address: address,
        delta_liquidity: u128,
        max_amount_a: u64,
        max_amount_b: u64,
        tick_lower: u64,
        tick_upper: u64,
        open_new_position: bool,
        position_index: u64,
    );

    /// Add liquidity into a pool with Coin and FungibleAsset. The position is identified by the name.
    /// The position token is identified by (creator, collection, name), the creator is pool address.
    /// Params
    ///     - pool_address
    ///     - delta_liquidity
    ///     - max_amount_a: the max number of asset_a can be consumed by the pool.
    ///     - max_amount_b: the max number of asset_b can be consumed by the pool.
    ///     - tick_lower
    ///     - tick_upper
    ///     - open_new_position: control whether or not to create a new position or add liquidity on existed position.
    ///     - index: position index. if `open_new_position` is true, index is no use.
    /// Returns
    native public entry fun add_liquidity_coin_asset<CoinType>(
        account: &signer,
        pool_address: address,
        delta_liquidity: u128,
        max_amount_a: u64,
        max_amount_b: u64,
        tick_lower: u64,
        tick_upper: u64,
        open_new_position: bool,
        position_index: u64,
    );

    /// Add liquidity into a pool with FungibleAssets. The position is identified by the name.
    /// The position token is identified by (creator, collection, name), the creator is pool address.
    /// Params
    ///     - pool_address
    ///     - delta_liquidity
    ///     - max_amount_a: the max number of asset_a can be consumed by the pool.
    ///     - max_amount_b: the max number of asset_b can be consumed by the pool.
    ///     - tick_lower
    ///     - tick_upper
    ///     - open_new_position: control whether or not to create a new position or add liquidity on existed position.
    ///     - index: position index. if `open_new_position` is true, index is no use.
    /// Returns
    native public entry fun add_liquidity(
        account: &signer,
        pool_address: address,
        delta_liquidity: u128,
        max_amount_a: u64,
        max_amount_b: u64,
        tick_lower: u64,
        tick_upper: u64,
        open_new_position: bool,
        position_index: u64,
    );


    /// Add liquidity into a pool with Coins. The position is identified by the name.
    /// The position token is identified by (creator, collection, name), the creator is pool address.
    /// Params
    ///     - pool_address
    ///     - amount_a: if fix_amount_a is false, amount_a is the max asset_a amount to be consumed.
    ///     - amount_b: if fix_amount_a is true, amount_b is the max asset_b amount to be consumed.
    ///     - fix_amount_a: control whether asset_a or asset_b amount is fixed
    ///     - tick_lower
    ///     - tick_upper
    ///     - open_new_position: control whether or not to create a new position or add liquidity on existed position.
    ///     - index: position index. if `open_new_position` is true, index is no use.
    /// Returns
    native public entry fun add_liquidity_fix_value_coin_coin<CoinTypeA, CoinTypeB>(
        account: &signer,
        pool_address: address,
        amount_a: u64,
        amount_b: u64,
        fix_amount_a: bool,
        tick_lower: u64,
        tick_upper: u64,
        open_new_position: bool,
        index: u64,
    );


    /// Add liquidity into a pool with CoinType and FungibleAsset. The position is identified by the name.
    /// The position token is identified by (creator, collection, name), the creator is pool address.
    /// Params
    ///     - pool_address
    ///     - amount_a: if fix_amount_a is false, amount_a is the max asset_a amount to be consumed.
    ///     - amount_b: if fix_amount_a is true, amount_b is the max asset_b amount to be consumed.
    ///     - fix_amount_a: control whether asset_a or asset_b amount is fixed
    ///     - tick_lower
    ///     - tick_upper
    ///     - open_new_position: control whether or not to create a new position or add liquidity on existed position.
    ///     - index: position index. if `open_new_position` is true, index is no use.
    /// Returns
    native public entry fun add_liquidity_fix_value_coin_asset<CoinType>(
        account: &signer,
        pool_address: address,
        amount_a: u64,
        amount_b: u64,
        fix_amount_a: bool,
        tick_lower: u64,
        tick_upper: u64,
        open_new_position: bool,
        position_index: u64,
    );

    /// Add liquidity into a pool with FungibleAssets. The position is identified by the name.
    /// The position token is identified by (creator, collection, name), the creator is pool address.
    /// Params
    ///     - pool_address
    ///     - amount_a: if fix_amount_a is false, amount_a is the max asset_a amount to be consumed.
    ///     - amount_b: if fix_amount_a is true, amount_b is the max asset_b amount to be consumed.
    ///     - fix_amount_a: control whether asset_a or asset_b amount is fixed
    ///     - tick_lower
    ///     - tick_upper
    ///     - open_new_position: control whether or not to create a new position or add liquidity on existed position.
    ///     - index: position index. if `open_new_position` is true, index is no use.
    /// Returns
    native public entry fun add_liquidity_fix_value(
        account: &signer,
        pool_address: address,
        amount_a: u64,
        amount_b: u64,
        fix_amount_a: bool,
        tick_lower: u64,
        tick_upper: u64,
        open_new_position: bool,
        index: u64,
    );

    /// Remove liquidity from a pool.
    /// The position token is identified by (creator, collection, name), the creator is pool address.
    /// Params
    ///     - pool_address
    ///     - delta_liquidity
    ///     - min_amount_a
    ///     - min_amount_b
    ///     - position_index: the position index to remove liquidity.
    ///     - is_close: is or not to close the position if position is empty.
    /// Returns
    native public entry fun remove_liquidity(
        account: &signer,
        pool_address: address,
        delta_liquidity: u128,
        min_amount_a: u64,
        min_amount_b: u64,
        position_index: u64,
        is_close: bool,
    );

    /// Provide to close position if position is empty.
    /// Params
    ///     - pool_address: The pool account address
    ///     - position_index: The position iindex
    /// Returns
    native public entry fun close_position(
        account: &signer,
        pool_address: address,
        position_index: u64,
    );

    /// Provide to the position to collect the fee of the position earned.
    /// Params
    ///     - pool_address: The pool account address
    ///     - position_index: The position index
    /// Returns
    native public entry fun collect_fee(
        account: &signer,
        pool_address: address,
        position_index: u64
    );

    /// Provide to the position to collect the rewarder of the position earned.
    /// Params
    ///     - pool_address: pool address.
    ///     - rewarder_index: the rewarder index(0,1,2).
    ///     - pos_index: the position index to collect rewarder.
    ///     - asset_addr: FungibleAsset Reward address
    /// Returns
    native public entry fun collect_rewarder(
        account: &signer,
        pool_address: address,
        rewarder_index: u8,
        pos_index: u64,
        asset_addr: address
    );

    /// Swap by Coin.
    /// Params
    ///     Type:
    ///         - CoinType
    ///     - account The swap tx signer
    ///     - pool_address: The pool account address
    ///     - a_to_b: true --> atob; false --> btoa
    ///     - by_amount_in: represent `amount` is the input(if a_to_b is true, then input is asset_a) amount to be consumed or output amount returned.
    ///     - amount
    ///     - amount_limit: if `by_amount_in` is true, `amount_limit` is the minimum outout amount returned;
    ///                     if `by_amount_in` is false, `amount_limit` is the maximum input amount can be consumed.
    ///     - sqrt_price_limit
    ///     - partner: The partner name
    /// Returns
    native public entry fun swap_coin<CoinType>(
        account: &signer,
        pool_address: address,
        a_to_b: bool,
        by_amount_in: bool,
        amount: u64,
        amount_limit: u64,
        sqrt_price_limit: u128,
        partner: String,
    );

    /// Swap by FungibleAsset.
    /// Params
    ///     - account The swap tx signer
    ///     - pool_address: The pool account address
    ///     - a_to_b: true --> atob; false --> btoa
    ///     - by_amount_in: represent `amount` is the input(if a_to_b is true, then input is asset_a) amount to be consumed or output amount returned.
    ///     - amount
    ///     - amount_limit: if `by_amount_in` is true, `amount_limit` is the minimum outout amount returned;
    ///                     if `by_amount_in` is false, `amount_limit` is the maximum input amount can be consumed.
    ///     - sqrt_price_limit
    ///     - partner: The partner name
    /// Returns
    native public entry fun swap(
        account: &signer,
        pool_address: address,
        a_to_b: bool,
        by_amount_in: bool,
        amount: u64,
        amount_limit: u64,
        sqrt_price_limit: u128,
        partner: String,
    );

    /// Deposit reward assets to the rewarder at a given index in the pool.
    /// Params
    ///     - account: The deposit signer
    ///     - pool_address: The pool account address
    ///     - rewarder_index: The rewarder index
    ///     - asset_addr: The reward asset address
    ///     - amount: Amount to deposit
    native public entry fun deposit_reward(
        account: &signer,
        pool_address: address,
        rewarder_index: u8,
        asset_addr: address,
        amount: u64
    );


    /// Update the rewarder emission.
    /// Params
    ///     - pool_address
    ///     - rewarder_index
    ///     - emission_per_second
    ///     - asset_addr: FungibleAsset Reward address
    /// Returns
    native public entry fun update_rewarder_emission(
        account: &signer,
        pool_address: address,
        rewarder_index: u8,
        emission_per_second: u128,
        asset_addr: address
    );

    /// Transfer the authority of a rewarder.
    /// Params
    ///     - pool_address
    ///     - rewarder_index
    ///     - new_authority
    /// Returns
    native public entry fun transfer_rewarder_authority(
        account: &signer,
        pool_addr: address,
        rewarder_index: u8,
        new_authority: address
    );

    /// Accept the authority of a rewarder.
    /// Params
    ///     - pool_address
    ///     - rewarder_index
    /// Returns
    native public entry fun accept_rewarder_authority(
        account: &signer,
        pool_addr: address,
        rewarder_index: u8,
    );

    /// Create a partner.
    /// The partner is identified by name.
    /// Params
    ///     - name: partner name.
    ///     - fee_rate
    ///     - receiver: the partner authority to claim the partner fee.
    ///     - start_time: partner valid start time.
    ///     - end_time: partner valid end time.
    /// Returns
    native public entry fun create_partner(
        account: &signer,
        name: String,
        fee_rate: u64,
        receiver: address,
        start_time: u64,
        end_time: u64
    );

    /// Transfer the receiver of a partner.
    /// Params
    ///     - name
    ///     - new_receiver
    /// Returns
    native public entry fun transfer_partner_receiver(account: &signer, name: String, new_recevier: address);

    /// Accept the recevier of a partner.
    /// Params
    ///     - name
    /// Returns
    native public entry fun accept_partner_receiver(account: &signer, name: String);

    /// Claim partner's ref fee
    /// Params
    ///     - account: The partner receiver account signer
    ///     - name: The partner name
    ///     - asset_type_addr: FungibleAsset type address
    /// Returns
    native public entry fun claim_ref_fee(account: &signer, name: String, asset_type_addr: address);

    /// Update the pool's position nft collection and token uri.
    /// Params
    ///     - account: The setter account signer
    ///     - pool_address: The pool address
    ///     - uri: The nft uri
    /// Returns
    native public entry fun update_pool_uri(account: &signer, pool_address: address, uri: String);

    /// Update the position nft collection and token uri.
    /// Params
    ///     - account: The setter account signer
    ///     - pool_address: The pool address
    ///     - uri: The nft uri
    ///     - start_index: The start index of the position nft to be updated
    ///     - end_index: The end index of the position nft to be updated
    /// Returns
    native public entry fun update_collection_and_nfts_uri(
        account: &signer,
        pool_address: address,
        uri: String,
        start_index: u64,
        end_index: u64
    );
}
