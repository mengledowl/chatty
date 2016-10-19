defmodule Chatty.RoomChannelTest do
	use Chatty.ChannelCase

	alias Chatty.RoomChannel

	setup do
		{:ok, _, socket} =
			socket("user_id", %{some: :assign})
			|> subscribe_and_join(RoomChannel, "room:lobby")

		{:ok, socket: socket}
	end

	test "ping replies with status ok", %{socket: socket} do
		ref = push socket, "ping", %{"hello" => "there"}
		assert_reply ref, :ok, %{"hello" => "there"}
	end

	test "shout broadcasts to room:lobby", %{socket: socket} do
		push socket, "shout", %{"hello" => "all"}
		assert_broadcast "shout", %{"hello" => "all"}
	end

	test "broadcast pushes to client", %{socket: socket} do
		broadcast_from! socket, "broadcast", %{"some" => "data"}
		assert_push "broadcast", %{"some" => "data"}
	end
end