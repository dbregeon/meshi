defmodule Meshi.RestaurantTest do
  use ExUnit.Case
  import Ecto.Changeset
  alias Meshi.Restaurant

  test "validate_url rejects url" do
    changeSet = cast(%Restaurant{}, %{url: "Test"}, [:url])
    assert Restaurant.validate_url(changeSet, :url).errors == [ { :url, { "invalid url: :no_scheme", [] } } ]
  end

  test "changeset rejects no name" do
    params = %{url: "https://test.com", posted_by: "Test User", posted_on: DateTime.utc_now()}
    assert Restaurant.changeset(%Restaurant{}, params).errors == [ { :name,  {"can't be blank", [validation: :required] } } ]
  end

  test "changeset rejects empty name" do
    params = %{name: "", url: "https://test.com", posted_by: "Test User", posted_on: DateTime.utc_now()}
    assert Restaurant.changeset(%Restaurant{}, params).errors == [ { :name,  {"can't be blank", [validation: :required] } } ]
  end

  test "changeset rejects no url" do
    params = %{name: "Test Restaurant", posted_by: "Test User", posted_on: DateTime.utc_now()}
    assert Restaurant.changeset(%Restaurant{}, params).errors == [ { :url,  {"can't be blank", [validation: :required] } } ]
  end

  test "changeset rejects empty url" do
    params = %{name: "Test Restaurant", url: "", posted_by: "Test User", posted_on: DateTime.utc_now()}
    assert Restaurant.changeset(%Restaurant{}, params).errors == [ { :url,  {"can't be blank", [validation: :required] } } ]
  end

  test "changeset rejects invalid url" do
    params = %{name: "Test Restaurant", url: "Test Url", posted_by: "Test User", posted_on: DateTime.utc_now()}
    assert Restaurant.changeset(%Restaurant{}, params).errors == [ { :url,  {"invalid url: :no_scheme", [] } } ]
  end
end
