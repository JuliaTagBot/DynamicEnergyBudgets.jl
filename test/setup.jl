using Test, DynamicEnergyBudgets, Unitful
using DynamicEnergyBudgets: STATELEN, Records, define_organs, split_state, sum_flux!, offset_apply!

# @testset "build records" begin
    # time=0u"hr":1u"hr":10u"hr"
    # a = build_record(build_flux(1.0u"mol/hr", [:one,:two], [:A,:B]), time)
    # @test axisnames(a) == (:time,)
    # @test axisvalues(a) == (0u"hr":1u"hr":10u"hr",)
    # @test axisnames(a[1]) == (:state, :transformations)
    # @test axisvalues(a[1]) == (([:one, :two]), ([:A, :B]))
    # @test a[1][:one,:A] == 0.0u"mol/hr"
    # @test a[2][:one,:A] == 0.0u"mol/hr"
    # a[1][:one,:A] = 10.0u"mol/hr"
    # @test a[0.0u"hr"][:one,:A] == 10.0u"mol/hr"
    # @test a[1.0u"hr"][:one,:A] == 0.0u"mol/hr"
    # o = Organ()
    # Records(o, time)
# end

@testset "sum_flux" begin
    du = fill(0.0u"mol/hr", 12)
    o = Organism();
    or1, or2 = define_organs(o, 1);
    or1.J .= [1.0,2.0,3.0,4.0,5.0,6.0]oneunit(or1.J[1,1])
    or2.J .= [1.0,2.0,3.0,4.0,5.0,6.0]oneunit(or2.J[1,1]) / 2
    sum_flux!(du, (or1, or2))
    @test du == [7.0,14.0,21.0,28.0,35.0,42.0,3.5,7.0,10.5,14.0,17.5,21.0] .* u"mol/hr" 
end

@testset "split_state" begin
    o = Organism();
    os = define_organs(o, 1);
    u = [1.0:12.0...]u"mol"
    us = split_state(os, u)
    @test us[1][1] == 1.0u"mol"
    @test us[2][1] == 7.0u"mol"
    @test sum(us[1]) == sum(1:6) .* u"mol"
    @test sum(us[2]) == sum(7:12) .* u"mol"
end
