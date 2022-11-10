%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_unsigned_div_rem
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.signature import verify_ecdsa_signature
from starkware.cairo.common.alloc import alloc

@storage_var
func _base_tokenURI(index: felt) -> (char: felt) {
}
 
func _set_base_tokenURI{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    base_tokenURI_len: felt, base_tokenURI: felt*
) {
    _write_base_token_uri(base_tokenURI_len, base_tokenURI);
    return ();
}

// Recursively store the array from the last character to the first one.
// We store value + 1 to differrentiate 0 values from unassigned ones.
func _write_base_token_uri{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    uri_len: felt, uri: felt*
) {
    if (uri_len == 0) {
        return ();
    }
    tempvar new_len = uri_len - 1;
    _base_tokenURI.write(new_len, uri[new_len] + 1);
    _write_base_token_uri(new_len, uri);
    return ();
}

// Recursively read the array from the first char to the last.
// We stop when we encounter the 0 value.
func _read_base_token_uri{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    array_len: felt, array: felt*
) -> (array_len: felt, array: felt*) {
    let (val) = _base_tokenURI.read(array_len);
    if (val == 0) {
        return (array_len, array);
    }
    assert array[array_len] = val - 1;
    return _read_base_token_uri(array_len + 1, array);
}


func _append_number_ascii{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    num: Uint256, arr: felt*
) -> (added_len: felt) {
    alloc_locals;
    local ten: Uint256 = Uint256(10, 0);
    let (q: Uint256, r: Uint256) = uint256_unsigned_div_rem(num, ten);
    let digit = r.low + 48;  // ascii

    if (q.low == 0 and q.high == 0) {
        assert arr[0] = digit;
        return (1,);
    }

    let (added_len) = _append_number_ascii(q, arr);
    assert arr[added_len] = digit;
    return (added_len + 1,);
}