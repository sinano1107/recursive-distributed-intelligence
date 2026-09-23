phenomenon(kitchen_lamp_on, [powered_when_plugged, lit_when_powered_and_on],
    [connected(kitchen), flipped(kitchen, on)],
    [expect(glows(kitchen))]).

phenomenon(hall_lamp_unplugged, [powered_when_plugged],
    [flipped(hall, on)],
    [refuse(glows(hall))]).
