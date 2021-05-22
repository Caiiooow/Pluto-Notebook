### A Pluto.jl notebook ###
# v0.14.3

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ d80124cc-fc1c-4e84-8c36-26b55c5a78f0
using Pkg

# ╔═╡ e10f0d04-0eb9-4540-8d47-59e887fb20fe
Pkg.add("ForwardDiff")

# ╔═╡ 60278e94-05b3-48c3-a2d4-bfa86ceef7b0
using Plots, PlutoUI

# ╔═╡ aa20515d-ada2-4128-b089-d1b44cfdc76d
using ForwardDiff

# ╔═╡ 6bec2aab-6265-4a09-bfef-e7e2302115df
ENV["GRDIR"]=""

# ╔═╡ bd77e334-6d61-4a0e-aa68-f5656e4ddc3d
Pkg.build("GR")

# ╔═╡ 558a8820-ba34-11eb-3a82-43e0c8b2fe3b
# Use CRL + ENTER to make it to other sell

# ╔═╡ 669c293a-ca3d-4979-963f-180b02c623b0
# So, Pluto has some functionalities and here we are going to explore them

# For example @bind

# ╔═╡ 256c2038-6b16-403d-a453-88bb0f1705c0
@bind a html"<input text=text"

# ╔═╡ 503d1611-94e0-43dc-ae2e-1c9a7cd36efd
Meta.parse(a) + 3

# ╔═╡ 45019d4c-ed48-4a5e-b86c-9b227c716da5
# But that is not the only thing in here 

# ╔═╡ bc9e4d2a-f9c9-4238-83df-34da0fb360c0
@bind b html"<input type=range min=1 max=20>"

# ╔═╡ 90530118-8c2e-4d2c-9151-6f88fc946064
b - 79 + 94

# ╔═╡ 1fccda3e-1449-4fd0-96a2-542a1eb4a9bd
# Sometimes your cell code become too big and a command becomes necessary

# ╔═╡ 07149d57-b55d-4d7e-a165-ae79275e9d92
begin
	r = Meta.parse(a)
	r + b
end

# ╔═╡ bdf5d8b8-4025-49cd-8f51-75a8813dfd37
# But not all of us know html to make all of these awesome commands, so we use some pre-builded ones

# ╔═╡ 70d258f2-bd2f-457d-bb59-ed08e0075590
@bind c  TextField()

# ╔═╡ 169a6b25-190a-457d-8891-29aeae563c8d
Meta.parse(c) + 10

# ╔═╡ ab50db00-0b00-404e-8d83-f11e3694ba06
@bind d Slider(1:100)

# ╔═╡ c8f72e41-ea51-461e-a180-a9c9a6a01764
begin
	y = Meta.parse(c)
	y + d,y
end

# ╔═╡ 089ed3b9-41af-4a3d-a0f0-62e38c8d3072
# There is also the Button command, which you can attribute the functionality that you want

# ╔═╡ 20519b14-33a4-412e-b688-4b6b94fed8f5
@bind u Button()

# ╔═╡ 376072db-e9b1-429c-9ca0-a4dc7b9c363b
begin
	u
	rand()
end


# ╔═╡ 2712ab0b-8947-4add-afad-dc13f1dc0052
# There is also the CheckBox, which you can use to say if something is true or false or if its on or off

# ╔═╡ ee50cef1-d32a-474b-bf10-288873c0093f
@bind h CheckBox()

# ╔═╡ 8609242c-992a-4276-8bbd-b016f020140c
h

# ╔═╡ 41c02509-064f-49f7-aa54-36c6abd40f11
@bind z Select(["k1" => π, "k2" => exp(1)])

# ╔═╡ 408e06fe-82fb-4cd2-867a-10147b2ffcea
# In order to make markdowns it is enough to do the following 

# ╔═╡ 16cc1192-89dc-4860-beee-1d4059868ebe
md"""
# This is a markdown

This still is a markdown

making other style of title
---------------------------
- a
- b
- c
- d

**a** e _b_

Here goes some LaTeX as well 

# $$f(x) = x^2 \Rightarrow f(A) = A^2$$

if wanted to write code inside the markdown: 

We can also make interpolations if our previous interactive variables, like

$a
$d
"""

# ╔═╡ 25914ad6-7654-4a78-93c1-d51a46849a57
pyplot()

# ╔═╡ 72c94ae4-09bd-4af1-85c0-d1c6962e2914
xg = LinRange(-2, 2, 100)

# ╔═╡ 5a279b16-1746-473d-87f1-64eced3c463d
md"""
w: $(@bind w Slider(-3:25, show_value = true))
p: $(@bind p Slider(xg, show_value = true))
"""

# ╔═╡ 8acd3111-f3d9-4b68-877c-99396ad5a77b
begin
	x = LinRange(-2, 2, 100)
	f(x) = x^2 * sin(x) + w * sin(x)
	
	fder(x) = ForwardDiff.derivative(f, x)
	fder2(x) = ForwardDiff.derivative(fder, x)
	T(x)  = f(p) + fder(p) * (x - p)
	P2(x) = T(x) + fder2(p) * (x - p)^2 / 2
end

# ╔═╡ 232b69c3-9dda-49a4-a280-fe8d4fe78d3b
begin
	
	plot(xg, f.(xg), c=:blue)
	
	plot!(xg, T.(xg), c=:red, leg = false)
	scatter!([p], [f(p)], c=:purple)
	plot!(xg, P2.(xg), c=:green, leg = false)
	ylims!(-2.5, 6)
end

# ╔═╡ 1cb9cdb6-79b0-4c1d-b05c-f2aa2d163eba
savefig("Taylor_Approx.png")

# ╔═╡ cfed1a97-7abd-41e2-a7dc-4be2f8253479
df = 2


# ╔═╡ d50150bc-ed0e-43ab-86bf-10608b01d670


# ╔═╡ 8906461f-a2fd-4307-a706-1c10d020eec3
anim = @animate for i = 1:df:length(xg)
	plot(xg, f.(xg), c=:blue)
	
	plot!(xg[1:i], T.(xg)[1:i], c=:red, leg = false)
	scatter!([p], [f(p)], i,c=:purple)
	plot!(xg[1:i], P2.(xg)[1:i], c=:green, leg = false)
	ylims!(-2.5, 6)
end

# ╔═╡ f6ba6de8-13f2-4132-817e-82f9e949c5a6
gif(anim, "TaylorSeriesApprox.gif", fps = 15)

# ╔═╡ Cell order:
# ╠═60278e94-05b3-48c3-a2d4-bfa86ceef7b0
# ╠═e10f0d04-0eb9-4540-8d47-59e887fb20fe
# ╠═aa20515d-ada2-4128-b089-d1b44cfdc76d
# ╠═d80124cc-fc1c-4e84-8c36-26b55c5a78f0
# ╠═6bec2aab-6265-4a09-bfef-e7e2302115df
# ╠═bd77e334-6d61-4a0e-aa68-f5656e4ddc3d
# ╠═558a8820-ba34-11eb-3a82-43e0c8b2fe3b
# ╠═669c293a-ca3d-4979-963f-180b02c623b0
# ╠═256c2038-6b16-403d-a453-88bb0f1705c0
# ╠═503d1611-94e0-43dc-ae2e-1c9a7cd36efd
# ╠═45019d4c-ed48-4a5e-b86c-9b227c716da5
# ╠═bc9e4d2a-f9c9-4238-83df-34da0fb360c0
# ╠═90530118-8c2e-4d2c-9151-6f88fc946064
# ╠═1fccda3e-1449-4fd0-96a2-542a1eb4a9bd
# ╠═07149d57-b55d-4d7e-a165-ae79275e9d92
# ╠═bdf5d8b8-4025-49cd-8f51-75a8813dfd37
# ╠═70d258f2-bd2f-457d-bb59-ed08e0075590
# ╠═169a6b25-190a-457d-8891-29aeae563c8d
# ╠═ab50db00-0b00-404e-8d83-f11e3694ba06
# ╠═c8f72e41-ea51-461e-a180-a9c9a6a01764
# ╠═089ed3b9-41af-4a3d-a0f0-62e38c8d3072
# ╠═20519b14-33a4-412e-b688-4b6b94fed8f5
# ╠═376072db-e9b1-429c-9ca0-a4dc7b9c363b
# ╠═2712ab0b-8947-4add-afad-dc13f1dc0052
# ╠═ee50cef1-d32a-474b-bf10-288873c0093f
# ╠═8609242c-992a-4276-8bbd-b016f020140c
# ╠═41c02509-064f-49f7-aa54-36c6abd40f11
# ╠═408e06fe-82fb-4cd2-867a-10147b2ffcea
# ╠═16cc1192-89dc-4860-beee-1d4059868ebe
# ╠═25914ad6-7654-4a78-93c1-d51a46849a57
# ╠═72c94ae4-09bd-4af1-85c0-d1c6962e2914
# ╠═5a279b16-1746-473d-87f1-64eced3c463d
# ╠═8acd3111-f3d9-4b68-877c-99396ad5a77b
# ╠═232b69c3-9dda-49a4-a280-fe8d4fe78d3b
# ╠═1cb9cdb6-79b0-4c1d-b05c-f2aa2d163eba
# ╠═cfed1a97-7abd-41e2-a7dc-4be2f8253479
# ╠═d50150bc-ed0e-43ab-86bf-10608b01d670
# ╠═8906461f-a2fd-4307-a706-1c10d020eec3
# ╠═f6ba6de8-13f2-4132-817e-82f9e949c5a6
