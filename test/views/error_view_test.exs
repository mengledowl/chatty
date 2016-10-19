defmodule Chatty.ErrorViewTest do
  use Chatty.ConnCase, async: true

  @moduletag :error_view_case

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  @tag individual_test: "yup"
  test "renders 404.html" do
    assert render_to_string(Chatty.ErrorView, "404.html", []) ==
           "Page not found"
  end

  @tag individual_test: "nope"
  test "render 500.html" do
    assert render_to_string(Chatty.ErrorView, "500.html", []) ==
           "Internal server error"
  end

  test "render any other" do
    assert render_to_string(Chatty.ErrorView, "505.html", []) ==
           "Internal server error"
  end
end
