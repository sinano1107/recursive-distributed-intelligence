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
  `failed(underivable(Obs))`, `failed(unexpected(Obs))`,
  `failed(vacuous(Obs))`, `failed(depth_exceeded(Obs))`, `pending(Reason)`.
- `explains(Phenomenon, Derivation)`: derives the Phenomenon's expected
  Observations by computing the closure of Core + Bridge rules over the
  Phenomenon's facts (bottom-up, so recursive Claims terminate and refusals
  are exact for a theory without function symbols). `Derivation` has one
  step per expectation: `derived(Obs, Trace)`, `refused(Obs)`,
  `underivable(Obs)`, `unexpected(Obs, Trace)`, `vacuous(Obs, Trace)`,
  `inconsistent(Obs, Trace, NegTrace)` or `depth_exceeded(Obs)`. A Trace is
  the list of steps one derivation passed through: `via(claim(Name), Goal)`,
  `via(bridge(Name), Goal)`, `fact(Goal)`.
- `render(Term, English)` / `parse(English, Term)`: DCG rendering of a Core
  term or a Claim clause (`Head :- Body`) into one English sentence, and its
  inverse. `parse/2` accepts only the Template language, never prose.
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

Files are read as terms, not consulted.

- `Clause` is `Head` or `(Head :- Body)`; parenthesise a conjunctive body.
  Bodies are conjunctions of goals; every goal must resolve (see load
  errors), which rules out built-ins and negation. Every head variable
  must occur in the body (see load errors).
- `Status` is `required`, `provisional` or `untested`.
- `DependsOn` lists the Claims the Phenomenon is written to test. A name
  that is not yet in the Core counts as `required` (red before green).
- `Facts` and the Observations in `Expectations` (`expect(Obs)` /
  `refuse(Obs)`) are in Observation vocabulary. Core vocabulary is every
  functor occurring in any Claim, head or body.
- `Excluded` is `claim(Name)` or `Functor/Arity`. The test is violated when
  any derivation of the Observation passes through it (the Observation's own
  goal counts, and so do derivations that revisit an atom, as through a
  symmetric Claim). An Observation with no derivation at all yields `explains`
  vacuously; the Phenomenon's own Verdict carries that failure.
- `Words` in a Template is a list of atoms; variables are argument slots.
  Clause bodies render as `... if ... and ...`; variables render as `A`,
  `B`, ... and parse back to fresh variables, so `parse(render(T))` is `T`
  up to variable renaming (`=@=`). Arguments must be atoms of one token: no
  whitespace, not `if`/`and`/a single capital letter; a number, compound or
  other atom raises `domain_error(template_argument, Arg)`.

## Load errors

`load_theory/1` (hence `check/2` and `cites_core/1`) throws
`theory_error(...)`:

- `misplaced(Kind, File)`: a term of the wrong kind for its directory, for
  example a `bridge/2` inside `phenomena/`.
- `core_vocabulary_in_phenomenon(F/A, File)`: a Phenomenon fact or
  Observation uses Core vocabulary.
- `range_violation(Var, Where)`: a Claim or Bridge rule head variable that
  does not occur in the body (`Where` is `claim(Name)` or `bridge(Name)`).
- `unresolved(F/A, Where)`: a Claim body goal that is no Claim or Bridge
  head; a Bridge body goal that is neither of those nor a fact some
  Phenomenon states; or a Phenomenon fact that no Bridge rule reads
  (`Where` is `claim(Name)`, `bridge(Name)` or `phenomenon(Name)`). `not/1`
  is looked through.
- `reserved_word(Word, F/A)`: a Template uses `if`, `and` or a single
  capital letter.
- `ambiguous_templates(F1/A1, F2/A2)`: two Templates with the same word
  pattern.
- `missing_template(F/A)` / `duplicate_template(F/A)`: a Core vocabulary
  item must have exactly one Template.

## Conventions

- **Negation**: `not(Obs)` is the declared negation of `Obs` in Observation
  vocabulary. A Phenomenon is `inconsistent` when both an expected (or
  refused) Observation and its negation are derivable. Only the Phenomenon's
  listed Observations are checked, not the whole closure.
- **Vacuous derivation**: an `expect` that is derivable but through none of
  the Claims in `DependsOn` (a trivialising Bridge rule, or a fact that
  restates the Observation) is `failed(vacuous(Obs))`. This is how a Bridge
  rule that bypasses the Core shows up in the Verdicts.
- **Depth bound**: derivation depth is capped (100) as a safety net for
  theories that build ever-new terms. If the closure has not settled within
  it, every test of that Phenomenon is `failed(depth_exceeded(Obs))`, never
  a clean `refuses` or `explains`.
- **Citation**: `[[claim_name]]` anywhere in a sentence. Headings (`#` lines)
  are ignored; a sentence ends at `.`, `!` or `?` when followed by the end of
  the text or by whitespace and a character that is not a lowercase letter
  (so `e.g. a gear` does not split); a sentence is substantive when it
  contains a letter. The prose's meaning is never checked.
- **Status**: a `failed(underivable(_))` or `failed(unexpected(_))` outcome
  stays `failed` when the test's dependencies include a `required` (or
  unknown) Claim, and becomes `pending(Reason)` when they are all
  `provisional`; `inconsistent`, `violates(_)`, `vacuous` and
  `depth_exceeded` are never softened. `untested` Claims are removed from
  the Core for derivation, and a test depending on one gets no Verdict at
  all.
