module dexlyn_clmm::tick_math {
    use integer_mate::i64::{Self, I64};

    #[view]
    /// Get the maximum sqrt price
    native public fun max_sqrt_price(): u128;

    #[view]
    /// Get the minimum sqrt price
    native public fun min_sqrt_price(): u128;

    #[view]
    /// Get the maximum tick
    native public fun max_tick(): i64::I64;

    #[view]
    /// Get the minimum tick
    native public fun min_tick(): i64::I64;

    #[view]
    /// Get the tick bound
    native public fun tick_bound(): u64;

    /// Get the sqrt price at a given tick
    /// Params
    ///     - tick The tick to get the sqrt price for
    /// Returns
    ///     - sqrt_price The sqrt price at the given tick
    native public fun get_sqrt_price_at_tick(tick: i64::I64): u128;

    /// Check if a given index is valid for a given tick spacing
    /// Params
    ///     - index The index to check
    ///     - tick_spacing The tick spacing to check against
    /// Returns
    ///     - bool True if the index is valid, false otherwise
    native public fun is_valid_index(index: I64, tick_spacing: u64): bool;

    #[view]
    /// Get the tick at a given sqrt price
    /// Params
    ///     - sqrt_price The sqrt price to get the tick for
    /// Returns
    ///     - tick The tick at the given sqrt price
    native public fun get_tick_at_sqrt_price(sqrt_price: u128): i64::I64;
}
