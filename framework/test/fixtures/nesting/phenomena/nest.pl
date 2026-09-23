phenomenon(gear_in_engine_in_car, [contains_direct, contains_transitive],
    [inside(gear, engine), inside(engine, car)],
    [expect(holds(car, gear))]).
% three levels: needs the transitive Claim to be applied to its own result
phenomenon(tooth_in_gear_in_engine_in_car, [contains_direct, contains_transitive],
    [inside(tooth, gear), inside(gear, engine), inside(engine, car)],
    [expect(holds(car, tooth))]).
phenomenon(car_is_unit, [whole_if_contains, contains_transitive],
    [inside(gear, engine), inside(engine, car)],
    [expect(unit(car))]).
% refusal that requires exhausting every derivation of a recursive Claim
phenomenon(gear_holds_nothing, [contains_direct, contains_transitive],
    [inside(gear, engine), inside(engine, car)],
    [refuse(holds(gear, car))]).
exclusion(nesting_without_whole, gear_in_engine_in_car, holds(car, gear), claim(whole_if_contains)).
% inconsistent: transitive containment says holds(car, gear), apart says not
phenomenon(gear_apart_from_car, [contains_direct, contains_transitive],
    [inside(gear, engine), inside(engine, car), apart(car, gear)],
    [expect(holds(car, gear))]).
