defmodule Chatty.UserControllerTest do
  use Chatty.ConnCase, async: true

  alias Chatty.User
  alias Chatty.{Repo, User}

  @valid_attrs %{bio: "some content", email: "some@email.com", name: "some content", number_of_pets: 4}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing users"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, user_path(conn, :new)
    assert html_response(conn, 200) =~ "New user"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @valid_attrs
    assert redirected_to(conn) == user_path(conn, :index)
    assert Repo.get_by(User, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert html_response(conn, 200) =~ "New user"
  end

  test "shows chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = get conn, user_path(conn, :show, user)
    assert html_response(conn, 200) =~ "Show user"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    response = get conn, user_path(conn, :show, -1)
    assert response.status == 404
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = get conn, user_path(conn, :edit, user)
    assert html_response(conn, 200) =~ "Edit user"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = put conn, user_path(conn, :update, user), user: @valid_attrs
    assert redirected_to(conn) == user_path(conn, :show, user)
    assert Repo.get_by(User, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit user"
  end

  test "deletes chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = delete conn, user_path(conn, :delete, user)
    assert redirected_to(conn) == user_path(conn, :index)
    refute Repo.get(User, user.id)
  end

  # API

  test "index/2 responds with all Users", %{conn: conn} do
    users = [ User.changeset(%User{}, %{name: "John", email: "john@example.com", bio: "John's bio"}),
              User.changeset(%User{}, %{name: "Jane", email: "jane@example.com", bio: "Jane's bio"}) ]

    Enum.each(users, &Repo.insert!(&1))

    response = conn
    |> get(user_path(conn, :index, _format: "json"))
    |> json_response(200)

    expected = %{
      "data" => [
        %{ "name" => "John", "email" => "john@example.com" },
        %{ "name" => "Jane", "email" => "jane@example.com" }
      ]
    }

    assert response == expected
  end

  test "show/2 responds with requested user" do
    user = Repo.insert!(User.changeset(%User{}, %{name: "John", email: "john@example.com", bio: "john's bio"}))

    response = conn
    |> get(user_path(conn, :show, user.id, _format: "json"))
    |> json_response(200)

    expected = %{"data"=> %{"name" => "John", "email" => "john@example.com"}}

    assert response == expected
  end

  test "show/2 responds with a message indicating user not found" do
    response = conn
    |> get(user_path(conn, :show, 300, _format: "json"))
    |> json_response(404)

    expected = %{"error" => "User not found"}

    assert response == expected
  end
end
