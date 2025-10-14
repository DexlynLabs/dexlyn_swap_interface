/// The FeeTiers info provide the fee_tier metadata used when create pool.
/// The FeeTier is stored in the deployed account(@dexlyn_clmm).
/// The FeeTier is identified by the tick_spacing.
/// The FeeTier can only be created and updated by the protocol.

module dexlyn_clmm::fee_tier {

    #[view]
    /// Get the fee rate for a given tick spacing.
    /// tick_spacing - Tick spacing to query.
    /// Returns the fee rate as `u64`.
    native public fun get_fee_rate(tick_spacing: u64): u64;

    #[view]
    /// Get the maximum allowed fee rate.
    /// Returns the max fee rate as `u64`.
    native public fun max_fee_rate(): u64;
}
