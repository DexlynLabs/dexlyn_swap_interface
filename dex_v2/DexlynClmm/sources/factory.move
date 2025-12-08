module dexlyn_clmm::factory {
    use std::option;
    use std::string::String;

    /// Creates a new liquidity pool with the specified parameters.
    /// Params
    ///     - account: The signer account creating the pool.
    ///     - tick_spacing: The tick spacing for the pool.
    ///     - initialize_price: The initial square root price of the pool.
    ///     - uri: The URI used for the token URI of the position token of this pool.
    ///     - asset_a_addr: The address of FungibleAsset A.
    ///     - asset_b_addr: The address of FungibleAsset B.
    /// Returns
    ///     - The address of the created pool.
    native public fun create_pool(
        account: &signer,
        tick_spacing: u64,
        initialize_price: u128,
        uri: String,
        asset_a_addr: address,
        asset_b_addr: address
    ): address;

    #[view]
    /// Get the address of a pool given its parameters.
    /// Params
    ///     - tick_spacing: The tick spacing of the pool.
    ///     - asset_a_addr: The address of FungibleAsset A.
    ///     - asset_b_addr: The address of FungibleAsset B.
    /// Returns
    ///     - The address of the pool.
    native public fun get_pool(
        tick_spacing: u64,
        asset_a_addr: address,
        asset_b_addr: address
    ): option::Option<address>;
}
