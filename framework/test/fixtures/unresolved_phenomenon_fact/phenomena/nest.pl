phenomenon(gear_in_engine, [contains_direct], [inside(gear, engine)], [expect(holds(engine, gear))]).
% the Observation stated as a fact: no Bridge rule reads holds/2
phenomenon(fact_is_observation, [contains_direct], [holds(engine, gear)], [expect(holds(engine, gear))]).
