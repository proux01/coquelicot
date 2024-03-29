Version 3.3.0
-------------

* improved support for complex arithmetic
* minimal version of Coq is now 8.12

Version 3.2.0
-------------

* added `closely` to filter over pairs of close values in place of `cauchy`

Version 3.1.0
-------------

* ensured compatibility from Coq 8.8 to Coq 8.13
* added some theorems about continuity and differentiability of elementary functions

Version 3.0.3
-------------

* ensured compatibility from Coq 8.8 to Coq 8.10

Version 3.0.2
-------------

* ensured compatibility from Coq 8.5 to Coq 8.9

Version 3.0.1
-------------

* ensured compatibility from Coq 8.5 to Coq 8.7

Version 3.0.0
-------------

* generalized `RInt` to `CompleteNormedModule`
* added `filterlimi` to express limits of implicitly-defined functions
* made `is_RInt_gen` similar to other limits and defined `RInt_gen`

Version 2.1.2
-------------

* fixed compilation with Coq 8.6; minimal version is now 8.5

Version 2.1.1
-------------

* fixed compilation with ssreflect 1.6

Version 2.1.0
-------------

* added `continuous` for expressing continuity
* modified definitions for `sum_n` and `sum_n_m`
* strengthened axioms for `AbsRing` and `NormedModule`
* added `closed` for characterizing closed sets
* added `iota` for Hilbert's operator on `CompleteSpace`
* added notation `[ _ , _ , ...]` for vectors of type `Tn`
* renamed `Markov*` lemmas to `LPO*`
* proved Abel's theorem on power series
* generalized continuity and differentiability of `RInt` in `RInt_analysis`
* added support for improper integrals in `RInt_gen`
* renamed `Limit` into `Lim_seq`
* added example `BacS2013_bonus` about matrices

Version 2.0.1
-------------

* fixed compilation with ssreflect 1.5

Version 2.0.0
-------------

* removed `is_derive` as a notation for `derivable_pt_lim`
* renamed some compatibility theorems from `_equiv` to `_Reals`
* introduced a hierarchy of number structures and topological spaces
* added complex numbers
* generalized `is_RInt`, `is_derive`, `is_domin`, etc, from reals to
  arbitrary left-modules

Version 1.1.0
-------------

* expressed `locally`, `Rbar_locally`, etc, as filters
* defined limits using `filterlim` and modified predicates such as `is_lim`
  accordingly
* simplified definitions of `Rbar` operators

Version 1.0.0
-------------

* initial release
