export bb_line!, bb_map!, plot_fm!, plot_fm, plot_mt!, plot_mt

setting_hide_axis = (xticksvisible = false, yticksvisible = false,
                     xticklabelsvisible = false, yticklabelsvisible = false,
                     xgridvisible = false, ygridvisible = false,
                     topspinevisible = false, bottomspinevisible = false,
                     leftspinevisible = false, rightspinevisible = false)

"""
```julia
bb_line!(ax, mt, x0, y0, rx, ry; kwargs...)
```

- `ax`
- `mt` `Union{SeisTools.Source.MomentTensor,SeisTools.Source.SDR}`
- `x0` (default 0.0)
- `y0` (default 0.0)
- `rx` (default 1.0)
- `ry` (default 1.0)

=== Keyword Parameters ===

- `proj` (default `:schmit`) `:schmit` or `:wulff`
- `dtheta` (default 1.0 )
- `planeline` (default `true`)
- `planelinewidth` (default 1)
- `planelinecolor` (default : `:black`)
- `circleline` (default `true`)
- `circlelinewidth` (default 4)
- `circlelinecolor` (default `:black`)
"""
function bb_line!(ax, mt::Union{SeisTools.Source.MomentTensor,SeisTools.Source.SDR},
                  x0::Real = 0.0, y0::Real = 0.0, rx::Real = 1.0, ry::Real = 1.0;
                  proj::Symbol = :schmit, dtheta::Real = 1.0,
                  planeline::Bool = true, planelinecolor = :black, planelinewidth = 1,
                  circleline::Bool = true, circlelinecolor = :black, circlelinewidth = 4)
    if proj == :schmit
        l = SeisTools.Source.beachball_sdrline_Schmit(mt, dtheta)
    else
        l = SeisTools.Source.beachball_sdrline_Wulff(mt, dtheta)
    end

    if planeline
        lines!(ax, map(p->(p[2] * rx + x0, p[1] * ry + y0), l.l1); color = planelinecolor, linewidth = planelinewidth)
        lines!(ax, map(p->(p[2] * rx + x0, p[1] * ry + y0), l.l2); color = planelinecolor, linewidth = planelinewidth)
    end
    if circleline
        lines!(ax, map(p->(p[2] * rx + x0, p[1] * ry + y0), l.edge); color = circlelinecolor,
               linewidth = circlelinewidth)
    end
    return ax
end

"""
```julia
bb_map!(ax, mt, x0, y0, rx, ry; kwargs...)
```

- `ax`
- `mt` `Union{SeisTools.Source.MomentTensor,SeisTools.Source.SDR}`
- `x0` (default 0.0)
- `y0` (default 0.0)
- `rx` (default 1.0)
- `ry` (default 1.0)

=== Keyword Parameters ===

- `proj` (default `:schmit`) `:schmit` or `:wulff`
- `resolution` (default 401)
- `pcolor` (default `:white`)
- `tcolor` (default `:black`)
"""
function bb_map!(ax, mt::Union{SeisTools.Source.MomentTensor,SeisTools.Source.SDR},
                 x0::Real = 0.0, y0::Real = 0.0, rx::Real = 1.0, ry::Real = 1.0;
                 proj::Symbol = :schmit, resolution::Integer = 401, pcolor = :white, tcolor = :black)
    if proj == :schmit
        m = SeisTools.Source.beachball_bitmap_Schmit(mt; resolution = (resolution, resolution))
    else
        m = SeisTools.Source.beachball_bitmap_Wulff(mt; resolution = (resolution, resolution))
    end
    xs = range(x0 - rx, x0 + rx; length = resolution)
    ys = range(y0 - ry, y0 + ry; length = resolution)
    heatmap!(ax, xs, ys, permutedims(sign.(m)); colormap = [pcolor, tcolor], nan_color = :transparent)
    return ax
end

"""
```julia
plot_fm!(ax, strike, dip, rake, x0, y0, xr, yr; kwargs...)
```

see `plot_fm` for keyword argument docs
"""
function plot_fm!(ax, strike::Real, dip::Real, rake::Real,
                  x0::Real = 0.0, y0::Real = 0.0, rx::Real = 1.0, ry::Real = 1.0;
                  proj::Symbol = :schmit, dtheta::Real = 1.0,
                  planeline::Bool = true, planelinecolor = :black, planelinewidth = 1,
                  circleline::Bool = true, circlelinecolor = :black, circlelinewidth = 4,
                  resolution::Integer = 401, pcolor = :white, tcolor = :black)
    sdr = SeisTools.Source.SDR(strike, dip, rake)
    bb_map!(ax, sdr, x0, y0, rx, ry; proj = proj, resolution = resolution, pcolor = pcolor, tcolor = tcolor)
    bb_line!(ax, sdr, x0, y0, rx, ry; proj = proj, dtheta = dtheta,
             planeline = planeline, planelinecolor = planelinecolor, planelinewidth = planelinewidth,
             circleline = circleline, circlelinecolor = circlelinecolor, circlelinewidth = circlelinewidth)
    return ax
end

"""
```julia
plot_fm(strike, dip, rake; kwargs...)
```

- strike
- dip
- rake

=== Keyword Parameters ===

- `proj` (default `:schmit`) `:schmit` or `:wulff`
- `dtheta` (default 1.0 )
- `planeline` (default `true`)
- `planelinewidth` (default 1)
- `planelinecolor` (default : `:black`)
- `circleline` (default `true`)
- `circlelinewidth` (default 4)
- `circlelinecolor` (default `:black`)
- `resolution` (default 401)
- `pcolor` (default `:white`)
- `tcolor` (default `:black`)
"""
function plot_fm(strike::Real, dip::Real, rake::Real;
                 proj::Symbol = :schmit, dtheta::Real = 1.0,
                 planeline::Bool = true, planelinecolor = :black, planelinewidth = 1,
                 circleline::Bool = true, circlelinecolor = :black, circlelinewidth = 4,
                 resolution::Integer = 401, pcolor = :white, tcolor = :black)
    axr0 = 1.05
    fig = Figure()
    ax = Axis(fig[1, 1]; limits = (-axr0, axr0, -axr0, axr0), aspect = 1, setting_hide_axis...)
    plot_fm!(ax, strike, dip, rake, 0, 0, 1, 1; proj = proj, dtheta = dtheta,
             planeline = planeline, planelinecolor = planelinecolor, planelinewidth = planelinewidth,
             circleline = circleline, circlelinecolor = circlelinecolor, circlelinewidth = circlelinewidth,
             resolution = resolution, pcolor = pcolor, tcolor = tcolor)
    return (fig, ax)
end

"""
```julia
plot_mt!(ax, m11, m22, m33, m12, m13, m23, x0, y0, xr, yr; kwargs...)
```

see `plot_mt` for keyword argument docs
"""
function plot_mt!(ax, m11::Real, m22::Real, m33::Real, m12::Real, m13::Real, m23::Real,
                  x0::Real = 0.0, y0::Real = 0.0, rx::Real = 1.0, ry::Real = 1.0;
                  proj::Symbol = :schmit, dtheta::Real = 1.0,
                  planeline::Bool = true, planelinecolor = :black, planelinewidth = 1,
                  circleline::Bool = true, circlelinecolor = :black, circlelinewidth = 4,
                  resolution::Integer = 401, pcolor = :white, tcolor = :black)
    mt = SeisTools.Source.MomentTensor(m11, m22, m33, m12, m13, m23)
    bb_map!(ax, mt, x0, y0, rx, ry; proj = proj, resolution = resolution, pcolor = pcolor, tcolor = tcolor)
    bb_line!(ax, mt, x0, y0, rx, ry; proj = proj, dtheta = dtheta,
             planeline = planeline, planelinecolor = planelinecolor, planelinewidth = planelinewidth,
             circleline = circleline, circlelinecolor = circlelinecolor, circlelinewidth = circlelinewidth)
    return (fig, ax)
end

"""
```julia
plot_mt(m11, m22, m33, m12, m13, m23; kwargs...)
```

- strike
- dip
- rake

=== Keyword Parameters ===

- `proj` (default `:schmit`) `:schmit` or `:wulff`
- `dtheta` (default 1.0 )
- `planeline` (default `true`)
- `planelinewidth` (default 1)
- `planelinecolor` (default : `:black`)
- `circleline` (default `true`)
- `circlelinewidth` (default 4)
- `circlelinecolor` (default `:black`)
- `resolution` (default 401)
- `pcolor` (default `:white`)
- `tcolor` (default `:black`)
"""
function plot_mt(m11::Real, m22::Real, m33::Real, m12::Real, m13::Real, m23::Real;
                 proj::Symbol = :schmit, dtheta::Real = 1.0,
                 planeline::Bool = true, planelinecolor = :black, planelinewidth = 1,
                 circleline::Bool = true, circlelinecolor = :black, circlelinewidth = 4,
                 resolution::Integer = 401, pcolor = :white, tcolor = :black)
    axr0 = 1.05

    fig = Figure()
    ax = Axis(fig[1, 1]; limits = (-axr0, axr0, -axr0, axr0), aspect = 1, setting_hide_axis...)
    plot_mt!(ax, m11, m22, m33, m12, m13, m23, 0, 0, 1, 1; proj = proj, dtheta = dtheta,
             planeline = planeline, planelinecolor = planelinecolor, planelinewidth = planelinewidth,
             circleline = circleline, circlelinecolor = circlelinecolor, circlelinewidth = circlelinewidth,
             resolution = resolution, pcolor = pcolor, tcolor = tcolor)
    return (fig, ax)
end
