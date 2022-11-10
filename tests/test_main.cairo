%lang starknet
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.alloc import alloc

from src.tokenURI import (
    _append_number_ascii,
)



// @external
// func test_uri{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}() {
//     alloc_locals;


//     let (len_uri, uri) = tokenURI(Uint256(123, 0));
//     assert 62 = len_uri;
//     assert uri[0] = 105;
//     assert uri[58] = 48 + 1;
//     assert uri[59] = 48 + 2;
//     assert uri[60] = 48 + 3;

//     return ();
// }

@external
func test_append_number_ascii{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    let number = Uint256(123450, 0);
    let (arr) = alloc();
    assert arr[0] = 1234567898765;
    let (added_len) = _append_number_ascii(number, arr + 1);
    assert added_len = 6;
    assert arr[0] = 1234567898765;
    assert arr[1] = 48 + 1;
    assert arr[2] = 48 + 2;
    assert arr[3] = 48 + 3;
    assert arr[4] = 48 + 4;
    assert arr[5] = 48 + 5;
    assert arr[6] = 48 + 0;
    return ();
}
