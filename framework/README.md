# Framework

A test-first harness for a theory written as a deterministic formal Core with
a Prose shell. It knows nothing about any particular theory. Everything is
SWI-Prolog (9.2); tests are plunit.

```sh
swipl -g run_tests -t halt framework/test/*.pl
```

## The four seams

Load `framework/prolog/framework.pl`. Everything else is internal.

- `check(TheoryDir, Verdicts)`: loads a theory directory, runs every
  Phenomenon and Exclusion test, and returns one `verdict(Name, Outcome)` per
  test. Outcomes: `explains`, `refuses`, `inconsistent`, `violates(Item)`,
  `failed(Reason)`, `pending(Reason)`.
- `explains(Phenomenon, Derivation)`: derives the Phenomenon's expected
  Observations with a small meta-interpreter over Core + Bridge rules + the
  Phenomenon's facts. `Derivation` has one step per expectation:
  `derived(Obs, Trace)`, `refused(Obs)`, `underivable(Obs)`,
  `unexpected(Obs, Trace)` or `inconsistent(Obs, Trace, NegTrace)`. A Trace
  is the list of steps the derivation passed through: `via(claim(Name), Goal)`,
  `via(bridge(Name), Goal)`, `fact(Goal)`.
- `render(Term, English)` / `parse(English, Term)`: DCG rendering of a Core
  term or a Claim clause (`Head :- Body`) into one English sentence, and its
  exact inverse. `parse/2` accepts only the Template language, never prose.
- `cites_core(ProseFile)`: succeeds iff every substantive sentence of the
  Markdown file cites at least one Claim that exists in the Core. The theory
  directory is taken to be the parent of the file's `prose/` directory.

`load_theory(Dir)` is exported too; `render/2` and `parse/2` use the
Templates of the theory loaded last (`check/2` and `cites_core/1` load).

## Theory directory layout

```
<theory>/
  core/*.pl        claim(Name, Status, Clause).    template(Head, Words).
  bridge/*.pl      bridge(Name, Clause).
  phenomena/*.pl   phenomenon(Name, DependsOn, Facts, Expectations).
                   exclusion(Name, PhenomenonName, Observation, Excluded).
  prose/*.md       Markdown with [[claim_name]] Citations.
```

Files are read as terms, not consulted. A term of the wrong kind for its
directory (for example a `bridge/2` inside `phenomena/`) is a load error
`theory_error(misplaced(Kind, File))`.

- `Clause` is `Head` or `(Head :- Body)`; parenthesise a conjunctive body.
  Bodies may only contain conjunctions of Core / Bridge / fact goals (no
  negation, no built-ins).
- `Status` is `required`, `provisional` or `untested`.
- `DependsOn` lists the Claims the Phenomenon is written to test. A name
  that is not yet in the Core counts as `required` (red before green).
- `Facts` and the Observations in `Expectations` (`expect(Obs)` /
  `refuse(Obs)`) are in Observation vocabulary. Core vocabulary is every
  functor occurring in any Claim, head or body; using one in a Phenomenon is
  a load error `theory_error(core_vocabulary_in_phenomenon(F/A, File))`.
- `Excluded` is `claim(Name)` or `Functor/Arity`. The test is violated when
  any derivation of the Observation passes through it (the Observation's own
  goal counts).
- `Words` in a Template is a list of atoms; variables are argument slots.
  Arguments must be atoms of one token, never a single capital letter (those
  are reserved for `'$VAR'(N)`, which renders as `A`, `B`, ...). Clause bodies
  render as `... if ... and ...`.

## Conventions

- **Negation**: `not(Obs)` is the declared negation of `Obs` in Observation
  vocabulary. A Phenomenon is `inconsistent` when both an expected (or
  refused) Observation and its negation are derivable. Only the Phenomenon's
  listed Observations are checked, not the whole closure.
- **Citation**: `[[claim_name]]` anywhere in a sentence. Headings (`#` lines)
  are ignored; sentences end at `.`, `!` or `?`; a sentence is substantive
  when it contains a letter. The prose's meaning is never checked.
- **Status**: a failing test whose dependencies include a `required` (or
  unknown) Claim yields `failed(Reason)`; one depending only on
  `provisional` Claims yields `pending(Reason)`. `untested` Claims are
  removed from the Core for derivation, and a test depending on one gets no
  Verdict at all.
