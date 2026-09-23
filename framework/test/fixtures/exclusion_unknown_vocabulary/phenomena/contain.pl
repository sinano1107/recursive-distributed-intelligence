phenomenon(gear_in_engine, [contains_direct], [inside(gear, engine)], [expect(holds(engine, gear))]).
exclusion(no_such_item, gear_in_engine, holds(engine, gear), sibling/2).
