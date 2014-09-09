Require Import Reals ssreflect ssrbool seq.
Require Import Rcomplements Hierarchy SF_seq.

Definition ith_step (ptd : @SF_seq R) i := nth 0 (SF_lx ptd) (S i) - nth 0 (SF_lx ptd) i.

Definition fine (delta : R -> posreal) ptd :=
  forall i : nat, (i < SF_size ptd)%nat -> ith_step ptd i < delta (nth 0 (SF_ly ptd) i).

Definition KH_filter (P : SF_seq -> Prop) :=
  exists delta, forall ptd, fine delta ptd -> P ptd.

Global Instance KH_filter_filter : Filter KH_filter.
Proof.
split.
exists (fun x => {| pos := 1; cond_pos := Rlt_0_1 |}).
intros ptd H.
easy.
intros P Q HP HQ.
destruct HP as (deltaP, HP).
destruct HQ as (deltaQ, HQ).
exists (fun x => {| pos := Rmin (deltaP x) (deltaQ x) ; cond_pos := (Rmin_stable_in_posreal (deltaP x) (deltaQ x))|}).
intros ptd Hptd.
split.
apply HP.
intros i Hi.
eapply Rlt_le_trans.
now apply (Hptd i).
apply Rmin_l.
apply HQ.
intros i Hi.
eapply Rlt_le_trans.
now apply (Hptd i).
apply Rmin_r.
intros P Q HPQ HP.
destruct HP as (delta, HP).
exists delta.
intros ptd Hptd.
apply HPQ ; now apply HP.
Qed.

Definition KH_fine (a b : R) :=
  within (fun ptd => pointed_subdiv ptd /\ SF_h ptd = Rmin a b /\ last (SF_h ptd) (SF_lx ptd) = Rmax a b) KH_filter.

Lemma lub_cara :
  forall E l, is_lub E l -> forall e : posreal, ~ ~ (exists x, E x /\ l - e < x).
Proof.
intros E l H e.
intro H0.
assert (forall x, ~ (E x /\ l - e < x)) as H1.
intros x Hx.
apply H0 ; now exists x.
clear H0.
unfold is_lub in H.
destruct H as (H, H0).
assert ( ~ is_upper_bound E (l-e)) as H2.
intro H2.
apply H0 in H2.
assert (0 < e) as H3.
apply (cond_pos e).
assert (l > l - e) as H4.
apply tech_Rgt_minus.
assumption.
unfold Rgt in H4.
destruct H2 as [H2 | H2].
assert (l < l) as H5.
now apply Rlt_trans with (l-e).
apply Rlt_irrefl in H5 ; contradiction.
rewrite <- H2 in H4.
apply Rlt_irrefl in H4 ; contradiction.
unfold is_upper_bound in H2.
assert (forall x : R, E x -> x <= l-e) as H3.
clear H0 ; clear H.
intro x.
assert (~ (E x /\ l - e < x)) as H.
apply H1.
clear H1.
intro H0.
assert ({l-e<x}+{l-e=x}+{l-e>x}).
apply total_order_T.
destruct H1 as [H1 | H1].
destruct H1 as [H1 | H1].
assert (E x /\ l-e < x).
now split.
contradiction.
right ; rewrite H1 ; trivial.
now left.
contradiction.
Qed.

Lemma cousin :
  forall a b delta, ~ ~ exists ptd,
  pointed_subdiv ptd /\ fine delta ptd /\
  SF_h ptd = Rmin a b /\ last (SF_h ptd) (SF_lx ptd) = Rmax a b.
Proof.
intros a b delta H.
assert (forall ptd, ~ (pointed_subdiv ptd /\ fine delta ptd /\ SF_h ptd = Rmin a b /\ last (SF_h ptd) (SF_lx ptd) = Rmax a b)) as Hdelta.
intros ptd Hptd.
apply H ; now exists ptd.
clear H.
set (M := fun y => Rmin a b <= y <= Rmax a b /\ exists ptd, (pointed_subdiv ptd /\
        fine delta ptd /\ SF_h ptd = Rmin a b /\ last (SF_h ptd) (SF_lx ptd) = y)).
assert (exists b', is_lub M b') as Hb'.
apply completeness_weak.
exists (Rmax a b).
intros y Hy.
apply Hy.
exists (Rmin a b).
split.
split.
apply Rle_refl.
apply Rmin_Rmax.
exists (SF_nil (Rmin a b)).
simpl.
split.
intros i Hi.
apply lt_n_0 in Hi ; destruct Hi.
split.
intros i Hi.
apply lt_n_0 in Hi ; destruct Hi.
split ; easy.
destruct Hb' as (b', H).
assert (forall e : posreal, ~ ~ (exists y, M y /\ b' - e < y)) as H1.
now apply lub_cara.
apply (H1 (delta b')).
intro H2.
destruct H2 as (y, H2).
clear H1.
destruct H2 as (H2, H1).
assert (M y) as Hy.
assumption.
destruct H2 as (H3, H2).
destruct H2 as (s, H2).
destruct H2 as (H2,H4).
destruct H4 as (H4, H0).
destruct H0 as (H5, H0).
set (s' := SF_rcons s (b',b')).
assert (pointed_subdiv s' /\ SF_h s' = Rmin a b /\ last (SF_h s') (SF_lx s') = b') as HH.
split.
unfold pointed_subdiv ; unfold s'.
intros i Hi.
rewrite SF_size_rcons in Hi.
apply lt_n_Sm_le in Hi.
case (eq_nat_dec i (SF_size s)) => His.
rewrite His.
replace (nth 0 (SF_lx (SF_rcons s (b', b'))) (SF_size s)) with (last (SF_h s) (SF_lx s)).
replace (nth 0 (SF_ly (SF_rcons s (b', b'))) (SF_size s)) with b'.
replace (nth 0 (SF_lx (SF_rcons s (b', b'))) (S (SF_size s))) with b'.
split.
rewrite H0.
unfold is_lub in H.
apply H.
apply Hy.
apply Rle_refl.
rewrite SF_lx_rcons.
simpl fst.
replace (S (SF_size s)) with (Peano.pred (size (rcons (SF_lx s) b')) ).
rewrite nth_last.
rewrite last_rcons.
easy.
rewrite size_rcons.
rewrite <- SF_size_lx.
simpl ; easy.
rewrite SF_ly_rcons.
simpl snd.
replace (SF_size s) with (Peano.pred (size (rcons (SF_ly s) b'))).
rewrite nth_last.
rewrite last_rcons.
easy.
rewrite size_rcons.
simpl.
apply SF_size_ly.
rewrite <- nth_last.
rewrite SF_size_lx.
simpl.
rewrite SF_lx_rcons.
simpl fst.
rewrite nth_rcons.
case Hleq : ssrnat.leq.
assert (Peano.pred(size (SF_lx s)) = size (SF_t s)) as Hlxsize.
rewrite SF_size_lx.
simpl ; unfold SF_size ; simpl ; easy.
unfold SF_size.
rewrite <- Hlxsize.
rewrite nth_last.
rewrite nth_last.
unfold SF_lx.
rewrite last_cons.
rewrite last_cons.
easy.
rewrite SF_size_lx in Hleq.
by rewrite ssrnat.leqnn in Hleq.
rewrite SF_lx_rcons.
rewrite SF_ly_rcons.
simpl fst.
simpl snd.
assert (i < SF_size s)%nat as Hsi.
apply le_lt_eq_dec in Hi.
now destruct Hi.
split ; rewrite nth_rcons ; case Hcase : ssrnat.leq ; rewrite nth_rcons ; case Hcase2 : ssrnat.leq.
now apply (H2 i).
case Hcase3 : eqtype.eq_op.
apply Rle_trans with (last (SF_h s) (SF_lx s)).
replace (last (SF_h s) (SF_lx s)) with (last 0 (SF_lx s)).
apply sorted_last.
apply ptd_sort.
apply H2.
rewrite SF_size_lx.
unfold lt.
apply le_n_S.
apply Hi.
case Hs : (SF_lx s).
assert (size (SF_lx s) = 0%nat) as Hss.
rewrite Hs ; simpl ; easy.
rewrite SF_size_lx in Hss.
apply NPeano.Nat.neq_succ_0 in Hss ; destruct Hss.
rewrite last_cons ; rewrite last_cons ; easy.
rewrite H0.
destruct H as (H, H').
now apply H.
move /ssrnat.leP :Hcase2 => Hcase2.
apply not_le in Hcase2 ; unfold gt in Hcase2.
rewrite SF_size_ly in Hcase2.
unfold lt in Hcase2.
apply le_S_n in Hcase2.
unfold lt in Hsi.
assert (S i <= i)%nat as Hcase4.
now apply le_trans with (SF_size s).
apply le_Sn_n in Hcase4 ; destruct Hcase4.
move /ssrnat.leP :Hcase => Hcase.
rewrite SF_size_lx in Hcase.
apply le_n_S in Hi.
contradiction.
move /ssrnat.leP :Hcase => Hcase.
rewrite SF_size_lx in Hcase.
apply le_n_S in Hi.
contradiction.
now apply (H2 i).
move /ssrnat.leP :Hcase2 => Hcase2.
rewrite SF_size_lx in Hcase2.
unfold lt in Hsi.
apply le_n_S in Hsi.
contradiction.
move /ssrnat.leP :Hcase => Hcase.
rewrite SF_size_ly in Hcase.
unfold lt in Hsi.
contradiction.
move /ssrnat.leP :Hcase => Hcase.
rewrite SF_size_ly in Hcase.
unfold lt in Hsi.
contradiction.
unfold s'.
split.
unfold SF_rcons.
simpl.
apply H5.
rewrite SF_lx_rcons.
rewrite last_rcons.
easy.
apply (Hdelta s').
split.
apply HH.
split.
unfold fine, s'.
rewrite SF_size_rcons.
unfold lt.
intros i Hi.
apply le_S_n in Hi.
case (le_lt_eq_dec i (SF_size s)).
assumption.
intro Hi2.
unfold ith_step.
replace (nth 0 (SF_lx (SF_rcons s (b', b'))) (S i)) with (nth 0 (SF_lx s) (S i)).
replace (nth 0 (SF_lx (SF_rcons s (b', b'))) i) with (nth 0 (SF_lx s) i).
replace (nth 0 (SF_ly (SF_rcons s (b', b'))) i) with (nth 0 (SF_ly s) i).
now apply (H4 i).
rewrite SF_ly_rcons.
simpl.
rewrite nth_rcons.
case Hcase : ssrnat.leq.
easy.
move /ssrnat.leP :Hcase => Hcase.
rewrite SF_size_ly in Hcase.
contradiction.
rewrite SF_lx_rcons.
rewrite nth_rcons.
case Hcase : ssrnat.leq.
easy.
move /ssrnat.leP :Hcase => Hcase.
rewrite SF_size_lx in Hcase.
apply le_n_S in Hi.
contradiction.
rewrite SF_lx_rcons.
rewrite nth_rcons.
case Hcase : ssrnat.leq.
easy.
move /ssrnat.leP :Hcase => Hcase.
rewrite SF_size_lx in Hcase.
apply le_n_S in Hi2.
contradiction.
clear Hi ; intro Hi.
rewrite Hi.
unfold ith_step.
rewrite SF_lx_rcons.
rewrite SF_ly_rcons.
replace (nth 0 (rcons (SF_lx s) (fst (b', b'))) (S (SF_size s))) with (last 0 (rcons (SF_lx s) (fst (b', b')))).
replace (nth 0 (rcons (SF_lx s) (fst (b', b'))) (SF_size s)) with y.
replace (nth 0 (rcons (SF_ly s) (snd (b', b'))) (SF_size s)) with (last 0 (rcons (SF_ly s) (snd (b', b')))).
rewrite last_rcons ; rewrite last_rcons ; simpl.
apply RIneq.Rplus_lt_reg_r with y.
rewrite Rplus_comm.
rewrite Rplus_assoc.
rewrite Rplus_opp_l.
rewrite Rplus_0_r.
apply RIneq.Rplus_lt_reg_r with (- delta b').
rewrite Rplus_comm.
replace (- delta b' + (y + delta b')) with y.
assumption.
rewrite Rplus_comm ; rewrite Rplus_assoc ; rewrite Rplus_opp_r ; rewrite Rplus_0_r ; easy.
replace (SF_size s) with (Peano.pred (size (rcons (SF_ly s) (snd (b', b'))))).
rewrite nth_last ; easy.
rewrite size_rcons.
simpl ; rewrite SF_size_ly ; easy.
rewrite nth_rcons.
rewrite SF_size_lx.
case Hcase : ssrnat.leq.
rewrite <- H0.
replace (SF_size s) with (Peano.pred (size (SF_lx s))).
rewrite nth_last.
case Hs : (SF_lx s).
assert (size (SF_lx s) = S (SF_size s)) as Hss.
apply SF_size_lx.
rewrite Hs in Hss.
unfold size in Hss.
apply O_S in Hss ; destruct Hss.
rewrite last_cons ; rewrite last_cons ; easy.
rewrite SF_size_lx ; simpl ; easy.
move /ssrnat.leP :Hcase => Hcase.
absurd (S (SF_size s) <= S (SF_size s))%nat.
assumption.
apply le_refl.
replace (S (SF_size s)) with (Peano.pred (size (rcons (SF_lx s) (fst (b', b'))))).
rewrite nth_last ; easy.
rewrite size_rcons ; rewrite SF_size_lx ; simpl ; easy.
destruct HH as (HH1, HH) ; split.
apply HH.
replace (Rmax a b) with b'.
apply HH.
assert ({b' < Rmax a b} + {b' = Rmax a b} + {b' > Rmax a b}) as Hb'.
apply total_order_T.
destruct Hb' as [Hb'1 | Hb'2].
destruct Hb'1 as [Hb'1 | Hb'3].
set (e:= Rmin ((Rmax a b) - b') ((delta b')/2) ).
assert (0 < e) as He.
apply Rmin_pos.
now apply Rlt_Rminus.
apply Rmult_lt_0_compat.
apply (cond_pos (delta b')).
apply Rinv_0_lt_compat.
apply (Rlt_R0_R2).
assert (e <= (delta b')/2) as Hed.
apply Rmin_r.
assert (e <= (Rmax a b) - b') as Hebb'.
apply Rmin_l.
assert (M (b' + e)) as H42.
unfold M.
split.
split.
apply Rle_trans with b'.
apply Rle_trans with y.
apply H3.
now apply H.
apply Rplus_le_reg_l with (- b').
rewrite Rplus_opp_l.
rewrite <- Rplus_assoc.
rewrite Rplus_opp_l.
rewrite Rplus_0_l.
now apply Rlt_le.
apply Rplus_le_reg_l with (- b').
rewrite <- Rplus_assoc.
rewrite Rplus_opp_l.
rewrite Rplus_0_l.
rewrite Rplus_comm.
assumption.
exists (SF_rcons s' (b'+e, b')).
split.
unfold pointed_subdiv.
rewrite SF_size_rcons ; rewrite SF_lx_rcons ; rewrite SF_ly_rcons.
intros i Hi.
case (le_lt_eq_dec i (SF_size s')).
apply le_S_n ; apply Hi.
intro Hi2.
replace (nth 0 (rcons (SF_lx s') (fst (b' + e, b'))) i) with (nth 0 (SF_lx s') i).
replace (nth 0 (rcons (SF_ly s') (snd (b' + e, b'))) i) with (nth 0 (SF_ly s') i).
replace (nth 0 (rcons (SF_lx s') (fst (b' + e, b'))) (S i)) with (nth 0 (SF_lx s') (S i)).
now apply (HH1 i).
rewrite nth_rcons.
case Hcase : ssrnat.leq.
easy.
move /ssrnat.leP :Hcase => Hcase.
rewrite SF_size_lx in Hcase.
apply le_n_S in Hi2 ; contradiction.
rewrite nth_rcons.
case Hcase : ssrnat.leq.
easy.
move /ssrnat.leP :Hcase => Hcase.
rewrite SF_size_ly in Hcase.
contradiction.
rewrite nth_rcons.
case Hcase : ssrnat.leq.
easy.
move /ssrnat.leP :Hcase => Hcase.
rewrite SF_size_lx in Hcase.
apply le_n_S in Hi2 ; contradiction.
intro Hi2.
replace i with (SF_size s').
replace (nth 0 (rcons (SF_lx s') (fst (b' + e, b'))) (SF_size s')) with b'.
replace (nth 0 (rcons (SF_ly s') (snd (b' + e, b'))) (SF_size s')) with (nth 0 (rcons (SF_ly s') (snd (b' + e, b'))) (Peano.pred (size (rcons (SF_ly s') (snd (b' + e, b')))))).
replace (nth 0 (rcons (SF_lx s') (fst (b' + e, b'))) (S (SF_size s'))) with (nth 0 (rcons (SF_lx s') (fst (b' + e, b'))) (Peano.pred (size (rcons (SF_lx s') (fst (b' + e, b')))))).
rewrite nth_last.
rewrite nth_last.
rewrite last_rcons.
rewrite last_rcons.
simpl.
split.
apply Rle_refl.
apply Rplus_le_reg_l with (- b').
rewrite Rplus_opp_l.
rewrite <- Rplus_assoc.
rewrite Rplus_opp_l ; rewrite Rplus_0_l.
now apply Rlt_le.
rewrite size_rcons ; rewrite SF_size_lx ; simpl ; easy.
rewrite size_rcons ; rewrite SF_size_ly ; simpl ; easy.
rewrite nth_rcons.
case Hcase : ssrnat.leq.
unfold s'.
rewrite SF_lx_rcons ; rewrite SF_size_rcons.
replace (S (SF_size s)) with (Peano.pred (size (rcons (SF_lx s) (fst (b', b'))))).
rewrite nth_last.
rewrite last_rcons.
easy.
rewrite size_rcons ; rewrite SF_size_lx ; simpl ; easy.
move /ssrnat.leP :Hcase => Hcase.
rewrite SF_size_lx in Hcase.
absurd (S (SF_size s') <= S (SF_size s'))%nat.
assumption.
apply le_refl.
split.
intro i.
rewrite SF_size_rcons.
intro Hi.
case (le_lt_eq_dec i (SF_size s')).
apply le_S_n.
apply Hi.
intro Hi2.
replace (ith_step (SF_rcons s' (b' + e, b')) i) with (ith_step s' i).
replace (nth 0 (SF_ly (SF_rcons s' (b' + e, b'))) i) with (nth 0 (SF_ly s') i).
unfold s'.
case (le_lt_eq_dec i (SF_size s)).
unfold s' in Hi2 ; rewrite SF_size_rcons in Hi2.
now apply le_S_n.
intro Hi3.
replace (ith_step (SF_rcons s (b', b')) i) with (ith_step s i).
replace (nth 0 (SF_ly (SF_rcons s (b', b'))) i) with (nth 0 (SF_ly s) i).
now apply (H4 i).
rewrite SF_ly_rcons ; rewrite nth_rcons.
case Hcase : ssrnat.leq.
easy.
move /ssrnat.leP :Hcase => Hcase.
rewrite SF_size_ly in Hcase.
contradiction.
unfold ith_step.
rewrite SF_lx_rcons.
rewrite nth_rcons ; case Hcase : ssrnat.leq ; rewrite nth_rcons.
case Hcase2 : ssrnat.leq.
easy.
move /ssrnat.leP :Hcase2 => Hcase2.
rewrite SF_size_lx in Hcase2.
absurd (S i <= S (SF_size s))%nat.
assumption.
apply le_n_S.
now apply lt_le_weak.
move /ssrnat.leP :Hcase => Hcase.
rewrite SF_size_lx in Hcase.
apply le_n_S in Hi3.
contradiction.
intro Hi3.
rewrite Hi3.
unfold ith_step.
rewrite SF_lx_rcons.
replace (nth 0 (rcons (SF_lx s) (fst (b', b'))) (S (SF_size s))) with b'.
replace (nth 0 (rcons (SF_lx s) (fst (b', b'))) (SF_size s)) with y.
replace (nth 0 (SF_ly (SF_rcons s (b', b'))) (SF_size s)) with b'.
apply RIneq.Rplus_lt_reg_r with y.
rewrite Rplus_comm.
rewrite Rplus_assoc.
rewrite Rplus_opp_l.
rewrite Rplus_0_r.
apply RIneq.Rplus_lt_reg_r with (- delta b').
rewrite Rplus_comm.
replace (- delta b' + (y + delta b')) with y.
apply H1.
rewrite Rplus_comm ; rewrite Rplus_assoc ; rewrite Rplus_opp_r ; rewrite Rplus_0_r ; easy.
rewrite SF_ly_rcons.
replace (SF_size s) with (Peano.pred (size (rcons (SF_ly s) (snd (b', b'))))).
rewrite nth_last.
rewrite last_rcons.
easy.
rewrite size_rcons.
simpl.
apply SF_size_ly.
rewrite nth_rcons.
case Hcase : ssrnat.leq.
replace (SF_size s) with (Peano.pred (size (SF_lx s))).
rewrite nth_last.
rewrite <- H0.
case Hs : (SF_lx s).
assert (size (SF_lx s) =S (SF_size s)) as Hss.
apply SF_size_lx.
rewrite Hs in Hss.
unfold size in Hss.
apply O_S in Hss ; destruct Hss.
rewrite last_cons ; rewrite last_cons ; easy.
rewrite SF_size_lx ; simpl ; easy.
move /ssrnat.leP :Hcase => Hcase.
absurd (S (SF_size s) <= size (SF_lx s))%nat.
assumption.
rewrite SF_size_lx ; easy.
replace (S (SF_size s)) with (Peano.pred (size (rcons (SF_lx s) (fst (b', b'))))).
rewrite nth_last.
rewrite last_rcons.
easy.
rewrite size_rcons ; rewrite SF_size_lx ; simpl ; easy.
unfold s'.
rewrite SF_ly_rcons.
rewrite SF_ly_rcons.
rewrite SF_ly_rcons.
case (le_lt_eq_dec i (SF_size s)).
unfold s' in Hi2 ; rewrite SF_size_rcons in Hi2 ; apply le_S_n ; apply Hi2.
intro Hi3.
rewrite nth_rcons ; rewrite nth_rcons ; rewrite nth_rcons.
case Hcase : ssrnat.leq.
case Hcase2 : ssrnat.leq.
easy.
move /ssrnat.leP :Hcase2 => Hcase2.
absurd (S i <= size (rcons (SF_ly s) (snd (b', b'))))%nat.
assumption.
rewrite size_rcons ; rewrite SF_size_ly.
apply le_n_S.
now apply lt_le_weak.
move /ssrnat.leP :Hcase => Hcase.
rewrite SF_size_ly in Hcase.
contradiction.
intro Hi3 ; rewrite Hi3.
replace (nth 0 (rcons (SF_ly s) (snd (b', b'))) (SF_size s)) with b'.
rewrite nth_rcons.
case Hcase : ssrnat.leq.
replace (SF_size s) with (Peano.pred (size (rcons (SF_ly s) (snd (b', b'))))).
rewrite nth_last.
rewrite last_rcons ; easy.
rewrite size_rcons ; rewrite SF_size_ly ; simpl ; easy.
move /ssrnat.leP :Hcase => Hcase.
absurd (S (SF_size s) <= size (rcons (SF_ly s) (snd (b', b'))))%nat.
assumption.
rewrite size_rcons ; rewrite SF_size_ly ; simpl ; easy.
rewrite nth_rcons.
case Hcase : ssrnat.leq.
move /ssrnat.leP :Hcase => Hcase.
rewrite SF_size_ly in Hcase.
apply le_Sn_n in Hcase ; destruct Hcase.
case Hcase2 : eqtype.eq_op.
easy.
rewrite SF_size_ly in Hcase2.
rewrite <- ssrnat.eqnE in Hcase2.
assert (forall n, ssrnat.eqn n n = true) as Hnn.
intro n.
induction n as [|n Hn].
simpl ; easy.
simpl ; apply Hn.
rewrite Hnn in Hcase2.
apply negbT in Hcase2.
unfold negb in Hcase2.
apply notF in Hcase2.
destruct Hcase2.
unfold ith_step.
rewrite SF_lx_rcons.
rewrite nth_rcons ; rewrite nth_rcons.
case Hcase : ssrnat.leq.
case Hcase2 : ssrnat.leq.
easy.
move /ssrnat.leP :Hcase2 => Hcase2.
rewrite SF_size_lx in Hcase2.
absurd (S i <= S (SF_size s'))%nat.
assumption.
apply lt_le_weak.
apply lt_n_S.
assumption.
move /ssrnat.leP :Hcase => Hcase.
absurd (S (S i) <= size (SF_lx s'))%nat.
assumption.
rewrite SF_size_lx.
now apply le_n_S.
intro Hi2 ; rewrite Hi2.
unfold ith_step.
rewrite SF_lx_rcons.
rewrite SF_ly_rcons.
replace (nth 0 (rcons (SF_lx s') (fst (b' + e, b'))) (S (SF_size s'))) with (b' + e).
replace (nth 0 (rcons (SF_lx s') (fst (b' + e, b'))) (SF_size s')) with b'.
replace (nth 0 (rcons (SF_ly s') (snd (b' + e, b'))) (SF_size s')) with b'.
rewrite Rplus_comm.
unfold Rminus.
rewrite Rplus_assoc ; rewrite Rplus_opp_r ; rewrite Rplus_0_r.
apply Rle_lt_trans with (delta b' / 2).
assumption.
apply Rminus_lt_0 ; field_simplify ; rewrite Rdiv_1.
by apply is_pos_div_2.
replace (SF_size s') with (Peano.pred (size (rcons (SF_ly s') (snd (b' + e, b'))))).
rewrite nth_last.
rewrite last_rcons.
easy.
rewrite size_rcons ; rewrite SF_size_ly ; simpl ; easy.
rewrite nth_rcons.
case Hcase : ssrnat.leq.
replace (SF_size s') with (Peano.pred (size (SF_lx s'))).
rewrite nth_last.
destruct HH as (HH, HH') ; rewrite <- HH'.
case Hcase2 : (SF_lx s').
assert (size (SF_lx s') = S (SF_size s')) as Hss.
apply SF_size_lx.
rewrite Hcase2 in Hss.
apply O_S in Hss ; destruct Hss.
rewrite last_cons ; rewrite last_cons ; easy.
rewrite SF_size_lx ; simpl ; easy.
move /ssrnat.leP :Hcase => Hcase.
absurd (S (SF_size s') <= size (SF_lx s'))%nat.
assumption.
rewrite SF_size_lx.
apply le_refl.
replace (S (SF_size s')) with (Peano.pred (size (rcons (SF_lx s') (fst (b' + e, b'))))).
rewrite nth_last ; rewrite last_rcons ; easy.
rewrite size_rcons ; rewrite SF_size_lx ; simpl ; easy.
rewrite SF_lx_rcons ; rewrite last_rcons.
split.
unfold SF_rcons ; simpl.
apply H5.
easy.
apply H in H42.
assert (b' < b' + e) as H43.
replace b' with (b' + 0).
rewrite Rplus_assoc.
apply Rplus_lt_compat_l.
now rewrite Rplus_0_l.
apply Rplus_0_r.
apply Rle_not_lt in H42.
contradiction.
apply Hb'3.
assert (b' <= Rmax a b) as Hb'3.
apply H.
intros x Hx.
apply Hx.
apply Rle_not_gt in Hb'3.
contradiction.
Qed.

Global Instance KH_fine_proper_filter a b : ProperFilter' (KH_fine a b).
Proof.
constructor.
unfold KH_fine ; unfold within ; unfold KH_filter.
intro H.
destruct H as (delta, Hdelta).
apply (cousin a b delta).
intro H.
destruct H as (ptd, Hptd).
apply (Hdelta ptd).
apply Hptd.
split.
apply Hptd.
split ; apply Hptd.
unfold KH_fine.
apply within_filter.
apply KH_filter_filter.
Qed.

Section is_KHInt.

Context {V : NormedModule R_AbsRing}.

Definition is_KHInt (f : R -> V) (a b : R) (If : V) :=
  filterlim (fun ptd => scal (sign (b-a)) (Riemann_sum f ptd)) (KH_fine a b) (locally If).

Definition ex_KHInt f a b :=
  exists If : V, is_KHInt f a b If.

Lemma is_KHInt_point :
  forall (f : R -> V) (a : R),
  is_KHInt f a a zero.
Proof.
intros f a.
unfold is_KHInt.
apply filterlim_ext with (fun ptd : @SF_seq R => @zero V).
intro ptd.
rewrite Rminus_eq_0.
unfold sign.
case Rle_dec => H0.
case Rle_lt_or_eq_dec => H1.
apply Rlt_irrefl in H1 ; destruct H1.
rewrite scal_zero_l ; easy.
apply Rnot_le_gt in H0 ; apply Rgt_irrefl in H0 ; destruct H0.
intros P HP.
unfold filtermap.
destruct HP as (eps, HPeps).
exists (fun x : R => {| pos := 1 ; cond_pos := Rlt_0_1 |}).
intros ptd Hptd Hptd2.
apply HPeps.
apply ball_center.
Qed.

Lemma ex_KHInt_point :
  forall (f : R -> V) (a : R),
  ex_KHInt f a a.
Proof.
intros f a ; exists zero ; now apply is_KHInt_point.
Qed.

Lemma is_KHInt_const :
  forall (a b : R) (c : V),
  is_KHInt (fun x : R => c) a b (scal (b-a) c).
Proof.
intros a b c.
intros P HP.
destruct HP as (eps, HPeps).
exists (fun x : R => eps).
intros ptd Hptd Hptd2.
apply HPeps.
rewrite Riemann_sum_const.
destruct Hptd2 as (Hptd0, Hptd1).
destruct Hptd1 as (Hptd1, Hptd2).
rewrite Hptd2.
rewrite Hptd1.
rewrite scal_assoc.
replace (mult (sign (b - a)) (Rmax a b - Rmin a b)) with (b-a).
apply ball_center.
unfold sign.
case Rle_dec => Hab.
case Rle_lt_or_eq_dec => Hab2.
rewrite mult_one_l.
rewrite Rmin_left.
rewrite Rmax_right.
easy.
apply Rge_le ; apply Rminus_ge ; now apply Rle_ge.
apply Rge_le ; apply Rminus_ge ; now apply Rle_ge.
rewrite <- Hab2 ; now rewrite mult_zero_l.
replace (Rmax a b) with a.
replace (Rmin a b) with b.
apply plus_reg_r with (mult 1 (a - b)).
assert (plus (mult (-1) (a - b)) (mult 1 (a - b)) = mult (plus (-1) 1) (a - b)) as H1.
now rewrite mult_distr_r.
rewrite H1 ; rewrite mult_one_l ; rewrite plus_opp_l ; rewrite mult_zero_l.
replace (b-a) with (opp (a-b)).
now rewrite plus_opp_l.
now rewrite opp_minus.
rewrite Rmin_right ; trivial.
apply Rnot_le_lt in Hab ; apply Rminus_lt in Hab ; now apply Rlt_le.
rewrite Rmax_left ; trivial.
apply Rnot_le_lt in Hab ; apply Rminus_lt in Hab ; now apply Rlt_le.
Qed.

Lemma ex_KHInt_const :
  forall (a b : R) (c : V),
  ex_KHInt (fun x : R => c) a b.
Proof.
intros a b c ; exists (scal (b-a) c) ; apply is_KHInt_const.
Qed.

End is_KHInt.