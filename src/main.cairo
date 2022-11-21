// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts for Cairo v0.4.0 (token/erc721/presets/ERC721MintableBurnable.cairo)

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_unsigned_div_rem
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.signature import verify_ecdsa_signature
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.hash import hash2
from starkware.cairo.common.bool import TRUE, FALSE

from cairo_contracts.src.openzeppelin.access.ownable.library import (
    Ownable, 
    Ownable_owner
)
from cairo_contracts.src.openzeppelin.introspection.erc165.library import ERC165
from cairo_contracts.src.openzeppelin.token.erc721.library import ERC721
from cairo_contracts.src.openzeppelin.upgrades.library import Proxy
from cairo_contracts.src.openzeppelin.token.erc721.enumerable.library import ERC721Enumerable

from src.tokenURI import (
    _base_tokenURI,
    _set_base_tokenURI,
    _write_base_token_uri,
    _read_base_token_uri,
    _append_number_ascii,
)


//
// Proxy 
// 

@external
func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    proxy_admin: felt
) {
    Proxy.initializer(proxy_admin);
    ERC721.initializer('Imperium Wars Key', 'IKEY');
    ERC721Enumerable.initializer();
    _whitelisting_key.write(799085134889162279411547463466380106946633091380230638211634583888488020853);
    Ownable.initializer(proxy_admin);

    // ///////////////
    // Init config //
    // ///////////////
    _set_base_tokenURI(
        88,
        new (104,116,116,112,115,58,47,47,98,97,102,121,98,101,105,97,107,110,53,120,122,100,107,117,55,110,105,117,122,52,54,114,104,99,109,97,102,121,51,114,51,53,109,117,104,114,110,55,114,117,102,108,120,103,100,102,103,50,110,100,105,101,120,121,101,122,101,46,105,112,102,115,46,110,102,116,115,116,111,114,97,103,101,46,108,105,110,107),
    );  // Set base token URI to: https://bafybeiakn5xzdku7niuz46rhcmafy3r35muhrn7ruflxgdfg2ndiexyeze.ipfs.nftstorage.link

    return ();
}

@external
func upgrade{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    new_implementation: felt
) {
    Proxy.assert_only_admin();
    Proxy._set_implementation_hash(new_implementation);
    return ();
}


//
// Storage
// 

@storage_var
func _whitelisting_key() -> (whitelisting_key: felt) {
}

@storage_var
func _blacklisted_mint(address: felt) -> (boolean: felt) {
}

//
// Getters
//

@view
func supports_Interface{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    interfaceId: felt
) -> (success: felt) {
    return ERC165.supports_interface(interfaceId);
}

@view
func name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (name: felt) {
    return ERC721.name();
}

@view
func symbol{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (symbol: felt) {
    return ERC721.symbol();
}

@view
func balanceOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(owner: felt) -> (
    balance: Uint256
) {
    return ERC721.balance_of(owner);
}

@view
func ownerOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(tokenId: Uint256) -> (
    owner: felt
) {
    return ERC721.owner_of(tokenId);
}

@view
func get_approved{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    tokenId: Uint256
) -> (approved: felt) {
    return ERC721.get_approved(tokenId);
}

@view
func is_approved_for_all{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    owner: felt, operator: felt
) -> (isApproved: felt) {
    let (isApproved: felt) = ERC721.is_approved_for_all(owner, operator);
    return (isApproved=isApproved);
}

@view
func base_tokenURI{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    base_tokenURI_len: felt, base_tokenURI: felt*
) {
    let (first_char) = _base_tokenURI.read(0);
    let (array) = alloc();
    let (base_tokenURI_len, base_tokenURI) = _read_base_token_uri(0, array);
    return (base_tokenURI_len, base_tokenURI);
}

@view
func tokenURI{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    tokenId: Uint256
) -> (tokenURI_len: felt, tokenURI: felt*) {
    alloc_locals;
    let (local base_token_uri_len, local base_token_uri) = base_tokenURI();

    return (base_token_uri_len, base_token_uri);
}

@external
func set_base_tokenURI{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    base_tokenURI_len: felt, base_tokenURI: felt*
) {
    Ownable.assert_only_owner();
    _set_base_tokenURI(base_tokenURI_len, base_tokenURI);
    return ();
}

@view
func owner{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (owner: felt) {
    return Ownable.owner();
}

@view
func owner2{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (owner: felt) {
    return Ownable.owner();
}

//
// Externals
//

@external
func approve{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    to: felt, tokenId: Uint256
) {
    ERC721.approve(to, tokenId);
    return ();
}

@external
func set_approval_for_all{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    operator: felt, approved: felt
) {
    ERC721.set_approval_for_all(operator, approved);
    return ();
}

@external
func transfer_from{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    from_: felt, to: felt, tokenId: Uint256
) {
    ERC721.transfer_from(from_, to, tokenId);
    return ();
} 

@external
func safe_transfer_from{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    from_: felt, to: felt, tokenId: Uint256, data_len: felt, data: felt*
) {
    ERC721.safe_transfer_from(from_, to, tokenId, data_len, data);
    return ();
}

@external
func whitelist_mint{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, ecdsa_ptr: SignatureBuiltin*
}(tokenId: Uint256, sig: (felt, felt)) {
    alloc_locals;

    let (caller) = get_caller_address();
    let (is_blacklisted) = _blacklisted_mint.read(caller);

    with_attr error_message("This address has already minted") {
        assert is_blacklisted = FALSE;
    }

    // Verify that the caller address is in the whitelist
    let (whitelisting_key) = _whitelisting_key.read();
    verify_ecdsa_signature(caller, whitelisting_key, sig[0], sig[1]);

    // blacklist the address
    _blacklisted_mint.write(caller, TRUE);

    // Mint the NFT
    _mint(tokenId);

    return ();
} 

@external
func end_whitelist{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    // Verify that caller is admin
    Ownable.assert_only_owner();

    // Set whitelist key to 0
    _whitelisting_key.write(0);
    return ();
}


func _mint{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
    tokenId: Uint256
) {
    let (to) = get_caller_address();
    ERC721._mint(to, tokenId);
    return ();
}

@external
func burn{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(tokenId: Uint256) {
    ERC721.assert_only_token_owner(tokenId);
    ERC721._burn(tokenId);
    return ();
}

@external
func transfer_ownership{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    newOwner: felt
) {
    Ownable.transfer_ownership(newOwner);
    return ();
}

@external
func renounce_ownership{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    Ownable.renounce_ownership();
    return ();
}
