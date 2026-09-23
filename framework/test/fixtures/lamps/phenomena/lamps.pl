phenomenon(kitchen_lamp_on, [powered_when_plugged, lit_when_powered_and_on],
    [connected(kitchen), flipped(kitchen, on)],
    [expect(glows(kitchen))]).

phenomenon(hall_lamp_unplugged, [powered_when_plugged],
    [flipped(hall, on)],
    [refuse(glows(hall))]).

phenomenon(flickering_lamp, [lit_when_powered_and_on, dark_when_off],
    [connected(cellar), flipped(cellar, on), flipped(cellar, off)],
    [expect(glows(cellar))]).

% Exclusion tests: the Derivation of glows(kitchen) must not pass through ...
exclusion(glows_without_dark, kitchen_lamp_on, glows(kitchen), claim(dark_when_off)).
exclusion(glows_without_power, kitchen_lamp_on, glows(kitchen), powered/1).
exclusion(glows_without_plugged_claim, kitchen_lamp_on, glows(kitchen), claim(powered_when_plugged)).

% Status handling.
phenomenon(shed_lamp_never_switched, [powered_when_plugged],   % required, fails
    [connected(shed)], [expect(glows(shed))]).
phenomenon(hall_lamp_plugged_and_on, [lit_when_powered_and_on], % required, refusal violated
    [connected(hall), flipped(hall, on)], [refuse(glows(hall))]).
phenomenon(moonlit_porch_lamp, [lit_when_bright_room],          % provisional, fails
    [moonlit(porch)], [expect(glows(porch))]).
phenomenon(enchanted_attic_lamp, [lit_by_magic],                 % untested: excluded
    [enchanted(attic)], [expect(glows(attic))]).
phenomenon(enchanted_attic_lamp_by_power, [lit_when_powered_and_on], % untested claim can't help
    [enchanted(attic)], [expect(glows(attic))]).
