defmodule Chatty.RoomChannel do
	use Phoenix.Channel

	def join("room:lobby", _message, socket) do
		send(self, :after_join)
		{:ok, socket}
	end

	def join("room:" <> _private_room_id, _params, _socket) do
		{:error, %{reason: "unauthorized"}}
	end

	def handle_info(:after_join, socket) do
		broadcast! socket, "new_msg", %{body: "New chatter joined the channel"}
		{:noreply, socket}
	end

	def handle_in("new_msg", %{"body" => body, "user_name" => user_name}, socket) do
		broadcast! socket, "new_msg", %{user_name: user_name, body: body}
		{:noreply, socket}
	end

	def handle_out("new_msg", payload, socket) do
		push socket, "new_msg", payload
		{:noreply, socket}
	end
end