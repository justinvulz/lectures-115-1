
$"Intuitionistic logic"$
- A logic without the Law of the Excluded Middle

![You just assumed the Law of the Excluded Middle](https://youtu.be/K2tUymm5o4M?si=kSthY_NsDwErVpb8)

---

In high school, we saw

Classical Logic (defined by truth table): 

A proposition $P, Q, R$ is 
- either a propositional variable or connectives ($not,∧, or ,→$) of propositions,
- has a truth value of either true $T$ or false $F$. 

The truth value of connectives is defined by the truth table below:

| $P$ | $Q$ | $not P$ | $P and Q$ | $P or Q$ | $P -> Q$ |
| --- | --- | ------- | --------- | -------- | -------- |
| $T$ | $T$ | $F$     | $T$       | $T$      | $T$      |
| $T$ | $F$ | $F$     | $F$       | $T$      | $F$      |
| $F$ | $T$ | $T$     | $F$       | $T$      | $T$      |
| $F$ | $F$ | $T$     | $F$       | $F$      | $T$      |

How to prove $not (P or Q) → (not P and not Q)$ ?

--- 

Just compute...

| $P$ | $Q$ | $P or Q$ | $not (P or Q)$ | $not P$ | $not Q$ | $not P and not Q$ | $not (P or Q) -> (not P and not Q)$ |
| --- | --- | -------- | -------------- | ------- | ------- | ----------------- | ----------------------------------- |
| $T$ | $T$ | $T$      | $F$            | $F$     | $F$     | $F$               | $bold(T)$                           |
| $T$ | $F$ | $T$      | $F$            | $F$     | $T$     | $F$               | $bold(T)$                           |
| $F$ | $T$ | $T$      | $F$            | $T$     | $F$     | $F$               | $bold(T)$                           |
| $F$ | $F$ | $F$      | $T$            | $T$     | $T$     | $T$               | $bold(T)$                           |

However, it is *NOT* how we prove a theorem!

--- 

To prove an implication $not (P or Q) text(fill: #red,→) (not P and not Q)$, 
we introduce the premise $not (P or Q)$ into our context, and try to derive the conclusion $not P and not Q$.

To prove a conjunction $not P text(fill: #red, and) not Q$,
we need to derive the two subgoals $not P$ and $not Q$ separately under the same context.

1. To prove a negation $text(fill: #red, not) P$,
we need to introduce the proposition $P$ into our context, and try to derive a contradiction.

current proof state
	context : $not (P or Q), P$
	goal: $"contradiction"$

Since $P$ holds, so $P or Q$ holds.
But now we have $not (P or Q)$ and $P or Q$, it is a contradiction.

2. To prove a negation $text(fill: #red, not) Q$,
we need to introduce the proposition $Q$ into our context, and try to derive a contradiction.

current proof state
	context : $not (P or Q), Q$
	goal: $"contradiction"$

Since $Q$ holds, so $P or Q$ holds.
But now we have $not (P or Q)$ and $P or Q$, it is a contradiction.

We get $not P$ and $not Q$ under the context $not (P or Q)$, so $not P and not Q$ hold under the context $not (P or Q)$.
We get $not P and not Q$ hold under the context $not (P or Q)$, so $not (P or Q) → (not P and not Q)$ under the "empty context". $qed$

---

Assume $not (P or Q)$ hold.
If $P$ hold, then $P or Q$, a contradiction.
If $Q$ hold, then $P or Q$, a contradiction.
Therefore, $not P and not Q$. $qed$

---

Key idea

At a moment of a proof, we have a *proof state*, consisting of 
- context: what we know, 
- goal: what we want to prove.

An *inference rule* is a transition between proof states.

We use inference rules to define what connectives mean, rather than using truth tables!!!

---

A *proposition* defines the grammar of a sentence.

$"Definition (Prop):"$ 
$$
"PV" A, B &::= mono(A) | mono(B) | mono(C) | ...
\
"Prop" P, Q &::= A | bot | P and Q | P or Q | P → Q 
$$
 In other words: 
 - Let $"PV" = {mono(A), mono(B), mono(C),...}$ be an infinite set of propositional variables.
 - Let $"Prop"$ be the set of all propositions, ***inductively*** defined by the following rules:
	 - $A$ is in $"Prop"$ for all $A$ in $"PV"$,
	 - $bot$ is in $"Prop"$, and
	 - $P and Q, P or Q, P → Q$ are in $"Prop"$, for all $P, Q$ in $"Prop"$.

Abbreviation:  $not P$ is a short hand of $P → bot$.

Convention: We implicitly add parentheses, e.g. $not P or not Q$ means $(not P) or (not Q)$, ...

Example: $not (P or Q) → (not P and not Q)$ is a proposition. 

---

A *judgment* formalizes a proof state.

$"Definition (Judgment)"$
$$
"Context" Γ &::= dot | Gamma, P
\
"Judgment" J &::= Gamma |- P
$$
In other words:
- A context $Gamma$ is a comma-separated finite list of propositions (including the empty list "$dot$").
- A judgment is a pair of a context $Gamma$ and a proposition $P$.

We pronounce $Gamma |- P$ as "$Gamma$ entail $P$".

Example: $not (P or Q) → (not P and not Q)$ is a proposition, and we write the judgment  $$|- not (P or Q) → (not P and not Q)$$ to say we want to prove this proposition without assuming anything.

---

An *inference rule* formalizes a transition from zero or more proof states to another proof state.

$"Definition (inference rule)"$
$$
(J_0 quad J_1 quad...  quad J_(n-1))/(J)("name")
$$
The judgments above/below the line are called premises/conclusion. 
How to use inference rules:
- Instantiate: Substitute variables with specific contexts or propositions.
- Compose: Stack matching inference rules to form a proof tree.

Example: We will see an inference rule:
$$
(Gamma, P |- Q)/(Gamma |- P → Q)("→I")
$$
This inference rule can be instantiated to (take $Gamma$ be $dot$, $P$ be $not (P or Q)$, $Q$ be $not P and not Q$) 
$$
(not (P or Q) |- not P and not Q)/(|- not (P or Q) → (not P and not Q))("→I")
$$
That is, to prove an implication $not (P or Q) text(fill: #red,→) (not P and not Q)$,
we introduce the premise $not (P or Q)$ into our context, and try to derive the conclusion $not P and not Q$.

---

Starting from a judgment, we will stack inference rules on it to build a proof tree until no premises remain. 
The resulting proof tree is called a *derivation* of the judgment.
A *proof* of a proposition $P$ is a derivation of the judgment $|-P$.

Example: The proof tree is a derivation of the judgment $|- not (P or Q) → (not P and not Q)$.

$$
#text(size: 9pt)[
#prooftree(
rule(name: [(→I)],
  rule(name: [(∧I)],
    rule(name: [(→I)], 
      rule(name: [(→E)],
        rule(name: [(A)],
          $not (P or Q), P ⊢ not (P or Q)$),
        rule(name: [(∨IL)],
          rule(name: [(A)], 
            $not (P or Q), P ⊢ P$),
          $not (P or Q), P ⊢ P or Q$),
      $not (P or Q), P ⊢ bot$),
      $not (P or Q) ⊢ not P$),
    rule(name: [(→I)], 
      rule(name: [(→E)],
        rule(name: [(A)],
          $not (P or Q), Q ⊢ not (P or Q)$),
        rule(name: [(∨IR)],
          rule(name: [(A)], 
            $not (P or Q), Q ⊢ Q$),
          $not (P or Q), Q ⊢ P or Q$),
      $not (P or Q), Q ⊢ bot$),
      $not (P or Q) ⊢ not Q$),
    $not (P or Q) tack not P and not Q$),
  $tack not (P or Q) → (not P and not Q)$,
))
]
$$

---

Recap

- Build propositions using connectives.
- Form a judgment by pairing a context with a goal proposition.
- Compose inference rules to derive a judgment.


A *natural deduction* system is a collection of inference rules. 
The **intuitionistic** variant we are introducing is named $"NJ"$ by [Gentzen](https://zh.wikipedia.org/zh-tw/%E6%A0%BC%E5%93%88%E5%BE%B7%C2%B7%E6%A0%B9%E5%B2%91).

---

Assumption rule: 
$$
()/(Gamma |- P)("A")
$$
with the *side condition* that $P$ appear in $Gamma$.

---

For each connective, we need to define how to construct it and how to use it.

If a connective appears in a premise/conclusion of an inference rule, 
this rule is called an *introduction*/*elimination* rule.

Conjunction:

- Introduction:
$$(Gamma |- P quad Gamma |- Q)/(Gamma |- P and Q)("∧I")$$
- Elimination:
$$(Gamma |- P and Q)/(Gamma |- P)("∧EL") quad (Gamma |- P and Q)/(Gamma |- Q)("∧ER")$$
Exercise: Derive $(P and Q) and R |- P and (Q and R)$

Use Obsidian Canvas: [[Exercise Blackboard.canvas]]

Implication:

- Introduction:
$$(Gamma, P |- Q)/(Gamma |- P → Q)("→I")$$
- Elimination:
$$(Gamma |- P → Q quad Gamma |- P)/(Gamma |- Q)("→E")$$
Exercise: Derive $(P and Q) → R |- P → (Q → R)$

Disjunction:

- Introduction:
$$(Gamma|- P)/(Gamma |- P or Q)("∨IL") quad (Gamma |- Q)/(Gamma |- P or Q)("∨IR")$$
- Elimination:
$$(Gamma |- P or Q quad Gamma,P |- R quad Gamma,Q |- R)/(Gamma |- R)("∨E")$$
Exercise: Derive $(P or Q) → R |- (P → R) and (Q → R)$

Falsity:

- Introduction: none
- Elimination:
$$(Gamma |- bot)/(Gamma |- P)("⊥E")$$
Exercise: Derive $P |- not not P$

--- 

Question: What is the difference between $→, |-, (J)/(J')$?
More precisely, do the following inference rules *imply* each other under $"NJ"$?
$$
()/(|- P → Q)
quad 
()/(Gamma |- P → Q)
quad
()/(P |- Q)
quad  
()/(Gamma, P |- Q)
quad  
(Gamma |- P)/(Gamma |- Q)
$$

We say an inference rule $(R_1)$ imply $(R_2)$ under a natural deduction $"N"$ system if 

One can replace any occurrences of the rule $(R_1)$ in a proof tree built by $N union {(R_1)}$ by a sub proof tree built by $N union {(R_2)}$. 

see: [[Exercise Blackboard.canvas]] (using *weakening rule*)

---

|             We can prove             | but not                            |                        |
| :----------------------------------: | ---------------------------------- | ---------------------- |
|        $not not (P or not P)$        | $P or not P$                       | law of excluded middle |
|           $P → not not P$            | $not not P → P$                    | double negation        |
| $(not P and not Q) <-> not (P or Q)$ |                                    | De Morgan's laws       |
|  $(not P or not Q) → not (P and Q)$  | $not (P and Q) → (not P or not Q)$ | De Morgan's laws       |
|     $(P → Q) → (not Q → not P)$      | $(not Q → not P) → (P → Q)$        | contraposition         |
|      $(not P or Q) →  (P → Q)$       | $(P → Q) → (not P or Q)$           | oh?                    |

Proof of "We can prove": [[Exercise Blackboard.canvas]]

Remarkably, in intuitionistic logic $"NJ"$:
- There are not concepts about truth value, and so the law of excluded middle and double negation are not trivial.
- Disjunction seems more stronger then in classical logic, it requires a explicit proof of $P$ or a proof of $Q$.

Question: How to prove these proposition $P$ in "but not" are not provable i.e. $tack.not P$.

---

The Law of The Excluded Middle

The classical natural deduction $"NK"$ is defined by $"NJ"$ adding the law of excluded middle $("LEM")$ or adding the double negation $("¬¬E")$
$$
()/(Gamma |- P or not P)("LEM")
quad 
()/(Gamma |- not not P → P)("¬¬E")
$$
Question: Why does adding one of the two rules suffice?

We say two inference rules $(R_1), (R_2)$ are *equivalent* under a natural deduction $"N"$ system if 

One can replace any occurrences of rule $(R_1)$ in a proof tree build by $N union {(R_1)}$ by a sub proof tree build by $N union {(R_2)}$, and vice versa. 

Exercise: Under $"NJ"$, the above two rule $("LEM"), ("¬¬E")$ also equivalent to the following two rules

$$
(Gamma, P |- Q quad Gamma, not P |- Q)/(Gamma |- Q)("by cases")
quad 
(Gamma, not P |- bot)/(Gamma |- P)("indirect proof")
$$

Exercise: also equivalent to 
$$
(Gamma |- P → Q)/(Gamma |- not P or Q)("oh?")
$$
Answer: [[Exercise Blackboard.canvas]]

!!!

[You just assumed the Law of the Excluded Middle](https://www.youtube.com/watch?v=K2tUymm5o4M)

 
---

Classical logic (defined by natural deduction) vs Classical logic (defined by truth table)

syntactic $Gamma |- P$ vs semantic $Gamma tack.r.double P$

see: [[Exercise Blackboard.canvas]]

---

Disjunction Property

Why can't we derive $Gamma |- P or not P$?

$"Theorem: (disjunction property):"$ 
Given a proof tree of $|-_"NJ" P_0 or P_1$, we can compute an index $i in {0, 1}$ along with a proof tree of $|-_"NJ" A_i$.

Question: What is the difference between the statement of the above theorem and 
"If $|-_"NJ" P ∨ Q$, then either $|-_"NJ" P$ or $|-_"NJ" Q$."?

Remark: The disjunction property does not hold for $"NK"$.
	
Question: Is the above remark related to the fact that the CH (Continuum Hypothesis) is independent of ZFC (Zermelo-Fraenkel set theory with the axiom of choice)?
	Gödel, 1940: $"ZFC" tack.not "CH"$
	Cohen, 1963: $"ZFC" tack.not not"CH"$
	Law of Excluded Middle: $"ZFC" |- "CH" or not "CH"$

Constructive Logic

---

finite vs infinite

Abbreviation:
Let $P "decidable"$ be a shorthand for $P or not P$
Let $Gamma "decidable"$ be a shorthand for $P_0 "decidable", P_1 "decidable", ..., P_(n-1) "decidable"$ 
- when $Gamma$ is $P_0, P_1, ..., P_(n-1)$

In $"NJ"$, we can derive

$$
P "decidable",&& not (not P) &|- P
\
P, Q "decidable",&& not (not P and not Q) &|- P or Q
\
P, Q, R "decidable",&& not (not P and not Q and not R) &|- P or Q or R
\
dots.v 
\
Gamma "decidable",&& not (and_(P in Gamma) P) &|- or_(P in Gamma) (not P)
$$

De Morgan's laws are allowed when the collection of propositions is *finite* and *decidable*.

In $"NK"$, all propositions are decidable. 
But more importantly, the law of excluded middle allows De Morgan's laws in an *infinite* setting.


Let prove $not (forall x. not P(x)) tack_"NK+∀∃" exists x. P(x)$ by natural language.

Assume $not (forall x. not P(x))$ holds.
By indirect proof, assume toward contradiction that $not (exists x. P(x))$ holds.
- Claim: $forall x. not P(x)$
	Let $x$ be such $P(x)$ holds.
	Then we find a $x$ such that $P(x)$. So $exists x. P(x)$ holds. Contradiction.
We get $forall x. not P(x)$, it contradiction to $not (forall x. not P(x))$ $qed$.

Question: Can we prove $forall x. (P(x) "decidable"), not (forall x. not P(x)) |-_"NJ+∀∃" exists x. P(x)$ ?


---

After this talk, you know
- How to use natural deduction (grammar, judgment, inference rule) to define a logic system.
- How to use inference rules to build a derivation of a proposition.
- You have a choice to accept the law of excluded middle or not.

![[Pasted image 20260905161131.png]]



---

Reference: 

2026 flolac 課程 邏輯
https://flolac.iis.sinica.edu.tw/zh/2026/
https://flolac.iis.sinica.edu.tw/2026/logic_lecture_I.pdf
https://flolac.iis.sinica.edu.tw/2026/logic_lecture_IV.pdf

Natural Deduction for Intuitionistic Logic | Attic Philosophy
https://youtu.be/7pmQkGLlqY0?si=NUmSKdZzSG6_y60p

Further reading: (I want to read it, but have no time, please, read it and teach me)

Constructive Analysis
https://link.springer.com/book/10.1007/978-3-642-61667-9

On intuitionistic linear logic
https://www.cl.cam.ac.uk/techreports/UCAM-CL-TR-346.html

From Classical to Intuitionistic Probability, Brian Weatherson
https://brian.weatherson.org/conprob.pdf

羅翔 bilibili 疑罪从无
https://www.bilibili.com/video/BV1DEcszgED9/?share_source=copy_web&vd_source=d3096126491cbef625f1873051b0f078

被告否認犯罪事實所持之辯解，縱屬不能成立，仍非有積極證據足以證明其犯罪行為，不能遽為有罪之認定。
https://mojlaw.moj.gov.tw/LawContentExShow.aspx?media=print&id=B,30,%E4%B8%8A,1831,001&type=J1