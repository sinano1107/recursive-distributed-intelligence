phenomenon(gear_in_engine, [contains_direct], [inside(gear, engine)], [expect(holds(engine, gear))]).
exclusion(no_such_phenomenon, gear_in_car, holds(engine, gear), claim(contains_direct)).
