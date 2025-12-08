/// The user position authority is represented by the token. User who own the token control the position.
/// Every pool has a collection, so all positions of this pool belongs to this collection.
/// The position unique index in a pool is stored in the token property map.
/// The `TOKEN_BURNABLE_BY_OWNER` is stored in every position default property_map, so the creator can burn the token when the liquidity of the position is zero.
module dexlyn_clmm::position_nft {
    use std::string::String;

    /// Details of a position NFT.
    struct NFTDetails has copy, drop, store {
        pool_address: address,
        position_index: u64,
        tick_lower: u64,
        tick_upper: u64,
        liquidity: u128,
    }


    #[view]
    /// Check if an address owns a position NFT in a collection.
    /// creator_address - Collection creator address.
    /// owner - Owner address.
    /// collection_name - Collection name.
    /// pool_index - Pool index.
    /// position_index - Position index.
    /// Returns `true` if owner, otherwise `false`.
    native public fun is_position_nft_owner(
        creator_address: address,
        owner: address,
        collection_name: String,
        pool_index: u64,
        position_index: u64
    ): bool;

    #[view]
    /// Generate the position nft name
    /// Params
    ///     - pool_index
    ///     - index: position index.
    /// Return
    ///     - string: position_name
    native public fun position_name(
        pool_index: u64,
        position_index: u64
    ): String;

    #[view]
    /// Generate the Position Token Collection Unique Name.
    /// "Dexlyn Position  | tokenA-tokenB_tick(#)"
    /// Params
    ///     - tick_spacing
    ///     - asset_a_addr: FungibleAsset A address
    ///     - asset_b_addr: FungibleAsset B address
    /// Return
    ///     - string: collection_name
    native public fun collection_name(
        tick_spacing: u64,
        asset_a_addr: address,
        asset_b_addr: address
    ): String;

    #[view]
    /// Get NFT details for a list of token addresses.
    /// token_addresses - Vector of token addresses.
    /// Returns a vector of `NFTDetails`.
    native public fun get_nft_details(token_addresses: vector<address>): vector<NFTDetails>;

    /// Get the fields of an NFTDetails struct.
    /// details - Reference to NFTDetails.
    /// Returns tuple of (pool address, position index, tick lower, tick upper, liquidity).
    native public fun get_nft_details_struct(details: &NFTDetails): (address, u64, u64, u64, u128);

    #[view]
    /// Check if an NFT is valid for a pool.
    /// token_address - NFT token address.
    /// pool_address - Pool address.
    /// Returns `true` if valid, otherwise `false`.
    native public fun is_valid_nft(
        token_address: address,
        pool_address: address,
    ): bool;
}
