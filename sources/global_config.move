/// The global config for dexlyn_swap: fees and manager accounts (admins).
module dexlyn_swap::global_config {

    /// Get DAO admin address.
    native public fun get_dao_admin(): address;

    /// Get emergency admin address.
    native public fun get_emergency_admin(): address;

    /// Get fee admin address.
    native public fun get_fee_admin(): address;

    /// Get default fee for pool.
    /// IMPORTANT: use functions in Liquidity Pool module as pool fees could be different from default ones.
    native public fun get_default_fee<Curve>(): u64;

    /// Get default DAO fee.
    native public fun get_default_dao_fee(): u64;

    #[view]
    native public fun get_global_config_addr(): address;
}
