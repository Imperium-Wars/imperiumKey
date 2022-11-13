%lang starknet
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.alloc import alloc
from cairo_contracts.src.openzeppelin.access.ownable.library import (
    Ownable, 
    Ownable_owner
)

from src.tokenURI import (
    _append_number_ascii,
)

from src.main import (
    set_base_tokenURI,
    tokenURI,
    base_tokenURI,
)

@external
func test_uri{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}() {
    alloc_locals;

    %{
        stop_prank_callable = start_prank(123)
    %}

    Ownable_owner.write(123);
    set_base_tokenURI(3, new (100, 101, 102));

    // test base base_tokenURI
    let (len_uri, uri) = base_tokenURI();
    assert 3 = len_uri;
    assert uri[0] = 100;
    assert uri[1] = 101;
    assert uri[2] = 102;

    // test base tokenURI
    let (len_uri, uri) = tokenURI(Uint256(123, 0));
    assert 6 = len_uri;
    assert uri[0] = 100;
    assert uri[1] = 101;
    assert uri[2] = 102;
    assert uri[3] = 48 + 1;
    assert uri[4] = 48 + 2;
    assert uri[5] = 48 + 3;

    return ();
}

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
