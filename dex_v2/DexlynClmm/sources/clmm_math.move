module dexlyn_clmm::clmm_math {
    use integer_mate::i64::I64;

    #[view]
    /// Get the fee rate numerator
    native public fun fee_rate_denominator(): u64;

    #[view]
    /// get liquidity from asset A
    /// Params
    ///     - sqrt_price_0
    ///     - sqrt_price_1
    ///     - amount_a
    ///     - round_up
    /// Returns
    ///     - liquidity
    native public fun get_liquidity_from_a(
        sqrt_price_0: u128,
        sqrt_price_1: u128,
        amount_a: u64,
        round_up: bool
    ): u128;

    #[view]
    /// get liquidity from asset B
    /// Params
    ///    - sqrt_price_0
    ///    - sqrt_price_1
    ///    - amount_b
    ///    - round_up
    /// Returns
    ///    - liquidity
    native public fun get_liquidity_from_b(
        sqrt_price_0: u128,
        sqrt_price_1: u128,
        amount_b: u64,
        round_up: bool
    ): u128;

    #[view]
    /// get delta asset A
    /// Params
    ///     - sqrt_price_0
    ///     - sqrt_price_1
    ///     - liquidity
    ///     - round_up
    /// Returns
    ///     - delta_a
    native public fun get_delta_a(
        sqrt_price_0: u128,
        sqrt_price_1: u128,
        liquidity: u128,
        round_up: bool
    ): u64 ;

    #[view]
    /// get delta asset B
    /// Params
    ///     - sqrt_price_0
    ///     - sqrt_price_1
    ///     - liquidity
    ///     - round_up
    /// Returns
    ///     - delta_b
    native public fun get_delta_b(
        sqrt_price_0: u128,
        sqrt_price_1: u128,
        liquidity: u128,
        round_up: bool
    ): u64;

    #[view]
    /// get next sqrt price after swap in direction A to B
    /// Params
    ///     - sqrt_price Current sqrt price
    ///     - liquidity Current liquidity in the range
    ///     - amount Amount of asset being swapped in or out
    ///     - by_amount_input True if the amount is the input amount, false if output amount
    /// Returns
    ///     - next sqrt price after swap
    native public fun get_next_sqrt_price_a_up(
        sqrt_price: u128,
        liquidity: u128,
        amount: u64,
        by_amount_input: bool,
    ): u128;

    #[view]
    /// get next sqrt price after swap in direction B to A
    /// Params
    ///     - sqrt_price Current sqrt price
    ///     - liquidity Current liquidity in the range
    ///     - amount Amount of asset being swapped in or out
    ///     - by_amount_input True if the amount is the input amount, false if output amount
    /// Returns
    ///     - next sqrt price after swap
    native public fun get_next_sqrt_price_b_down(
        sqrt_price: u128,
        liquidity: u128,
        amount: u64,
        by_amount_input: bool,
    ): u128;

    #[view]
    /// get next sqrt price from input amount
    /// Params
    ///     - sqrt_price Current sqrt price
    ///     - liquidity Current liquidity in the range
    ///     - amount Amount of asset being swapped in
    ///     - a_to_b True if the swap direction is A to B, false if B to A
    /// Returns
    ///     - The next sqrt price after swap
    native public fun get_next_sqrt_price_from_input(
        sqrt_price: u128,
        liquidity: u128,
        amount: u64,
        a_to_b: bool,
    ): u128;

    #[view]
    /// get next sqrt price from output amount
    /// Params
    ///     - sqrt_price Current sqrt price
    ///     - liquidity Current liquidity in the range
    ///     - amount Amount of asset being swapped out
    ///     - a_to_b True if the swap direction is A to B, false if B to A
    /// Returns
    ///     - The next sqrt price after swap
    native public fun get_next_sqrt_price_from_output(
        sqrt_price: u128,
        liquidity: u128,
        amount: u64,
        a_to_b: bool,
    ): u128;

    #[view]
    /// get delta asset from input amount
    /// Params
    ///     - current_sqrt_price Current sqrt price
    ///     - target_sqrt_price Target sqrt price after swap
    ///     - liquidity Current liquidity in the range
    ///     - a_to_b True if the swap direction is A to B, false if B to A
    /// Returns
    ///     - delta asset amount required to move the price to the target sqrt price
    native public fun get_delta_up_from_input(
        current_sqrt_price: u128,
        target_sqrt_price: u128,
        liquidity: u128,
        a_to_b: bool,
    ): u256;

    #[view]
    /// get delta asset from output amount
    /// Params
    ///     - current_sqrt_price Current sqrt price
    ///     - target_sqrt_price Target sqrt price after swap
    ///     - liquidity Current liquidity in the range
    ///     - a_to_b True if the swap direction is A to B, false if B to A
    /// Returns
    ///     - delta asset amount required to move the price to the target sqrt price
    native public fun get_delta_down_from_output(
        current_sqrt_price: u128,
        target_sqrt_price: u128,
        liquidity: u128,
        a_to_b: bool,
    ): u256;

    #[view]
    /// Compute a swap step
    /// Params
    ///     - current_sqrt_price Current sqrt price
    ///     - target_sqrt_price Target sqrt price after swap
    ///     - liquidity Current liquidity in the range
    ///     - amount Amount of asset being swapped in or out
    ///     - fee_rate The fee rate for the swap
    ///     - a2b True if the swap direction is A to B, false if B to A
    ///     - by_amount_in True if the amount is the input amount, false if output amount
    /// Returns
    ///     - amount_in The actual amount of asset being swapped in
    ///     - amount_out The actual amount of asset being swapped out
    ///     - next sqrt price after swap
    ///     - fee_amount The fee amount charged for the swap
    native public fun compute_swap_step(
        current_sqrt_price: u128,
        target_sqrt_price: u128,
        liquidity: u128,
        amount: u64,
        fee_rate: u64,
        a2b: bool,
        by_amount_in: bool
    ): (u64, u64, u128, u64);

    /// Get the asset amount by liquidity
    /// Params
    ///     - tick_lower The liquidity's lower tick
    ///     - tick_upper The liquidity's upper tick
    ///     - current_tick_index
    ///     - current_sqrt_price
    ///     - liquidity
    ///     - round_up  
    /// Returns
    ///     - amount_a
    ///     - amount_b
    native public fun get_amount_by_liquidity(
        tick_lower: I64,
        tick_upper: I64,
        current_tick_index: I64,
        current_sqrt_price: u128,
        liquidity: u128,
        round_up: bool
    ): (u64, u64);

    /// Get the liquidity from amount
    /// Params
    ///     - lower_index
    ///     - upper_index
    ///     - current_tick_index
    ///     - current_sqrt_price
    ///     - amount
    ///     - is_fixed_a
    /// Returns
    ///     - liquidity
    ///     - amount_a
    ///     - amount_b
    native public fun get_liquidity_from_amount(
        lower_index: I64,
        upper_index: I64,
        current_tick_index: I64,
        current_sqrt_price: u128,
        amount: u64,
        is_fixed_a: bool
    ): (u128, u64, u64);
}



