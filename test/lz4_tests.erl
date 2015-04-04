-module(lz4_tests).

-include_lib("eunit/include/eunit.hrl").

test_data() ->
    Raw = <<"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.">>,
    binary:copy(Raw, 10000).

compress_test() ->
    Raw = test_data(),
    {ok, Comp} = lz4:compress(Raw),
    {ok, Uncomp} = lz4:uncompress(Comp, byte_size(Raw)),
    ?assertEqual(Raw, Uncomp).

high_compress_test() ->
    Raw = test_data(),
    {ok, Comp} = lz4:compress(Raw, [high]),
    {ok, Uncomp} = lz4:uncompress(Comp, byte_size(Raw)),
    ?assertEqual(Raw, Uncomp).

pack_test() ->
    Raw = test_data(),
    {ok, Pack} = lz4:pack(Raw),
    {ok, Unpack} = lz4:unpack(Pack),
    <<Size:32/unsigned-integer, _/binary>> = Pack,
    ?assertEqual(size(Raw), Size),
    ?assertEqual(Raw, Unpack).

zero_compress_test() ->
    Raw = <<>>,
    {ok, Comp} = lz4:compress(Raw),
    {ok, Uncomp} = lz4:uncompress(Comp, byte_size(Raw)),
    ?assertEqual(Raw, Uncomp).

zero_high_compress_test() ->
    Raw = <<>>,
    {ok, Comp} = lz4:compress(Raw, [high]),
    {ok, Uncomp} = lz4:uncompress(Comp, byte_size(Raw)),
    ?assertEqual(Raw, Uncomp).

zero_pack_test() ->
    Raw = <<>>,
    {ok, Pack} = lz4:pack(Raw),
    {ok, Unpack} = lz4:unpack(Pack),
    <<Size:32/unsigned-integer, _/binary>> = Pack,
    ?assertEqual(size(Raw), Size),
    ?assertEqual(Raw, Unpack).
