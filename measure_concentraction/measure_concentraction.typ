#import "typst_packages/slide.typ":*
#import "@preview/cetz:0.5.2"

#show : doc=> conf(
  author: "Po Hsuan Chen",
  author-full: "Po Hsuan Chen",
  title: "An Introduction to Measure Concentration Phenomenon",
  title-full:"An Introduction to Measure Concentration Phenomenon",
  doc
)

//
//
//  the audience of this slide is freshman, so we introudce the basic metric and measure space first
//  then reference this  USRP_Group_5__Copy_.pdf for the last part
//  the metric/ measure space , show the definition first and use the RR^1 and sphere for the example,

// northern hemisphere A of a great circle, and its r-neighbourhood A_r
#let hemi-fig = cetz.canvas(length: 1.8cm, {
  import cetz.draw: *
  line((-1.3, 0), (1.3, 0), stroke: (paint: gray, dash: "dashed"))
  circle((0, 0), radius: 1, stroke: gray)
  arc((0, 0), start: -20deg, stop: 200deg, radius: 1, anchor: "origin", stroke: 4pt + orange)
  arc((0, 0), start: 0deg, stop: 180deg, radius: 1, anchor: "origin", stroke: 4pt + blue)
  content((0, 1.3), text(blue)[$A$])
  content((1.25, -0.55), text(orange)[$A_r$])
})

// S^2 with two points x, y: the straight segment |x - y| and the great-circle arc d(x, y)
#let sphere-fig = cetz.canvas(length: 2.6cm, {
  import cetz.draw: *
  let tilt = 20deg
  // orthographic projection, viewed slightly from above
  let proj(p) = (p.at(0), p.at(1) * calc.sin(tilt) + p.at(2) * calc.cos(tilt))
  let pt(lon, lat) = (calc.cos(lat) * calc.cos(lon), calc.cos(lat) * calc.sin(lon), calc.sin(lat))
  let equator(a, b) = range(0, 61).map(i => proj(pt(a + (b - a) * i / 60, 0deg)))
  circle((0, 0), radius: 1, stroke: gray)
  line(..equator(180deg, 360deg), stroke: gray)
  line(..equator(0deg, 180deg), stroke: (paint: gray, dash: "dashed"))
  let x = pt(-175deg, 30deg)
  let y = pt(-5deg, 40deg)
  let om = calc.acos(x.zip(y).map(((p, q)) => p * q).sum())
  let geo = range(0, 41).map(i => {
    let (a, b) = (calc.sin((1 - i / 40) * om), calc.sin(i / 40 * om))
    proj(x.zip(y).map(((p, q)) => (a * p + b * q) / calc.sin(om)))
  })
  let (px, py) = (proj(x), proj(y))
  line(..geo, stroke: 2.5pt + blue)
  line(px, py, stroke: 2.5pt + orange)
  circle(px, radius: 0.035, fill: black)
  circle(py, radius: 0.035, fill: black)
  content(px, $x$, anchor: "east", padding: 0.08)
  content(py, $y$, anchor: "west", padding: 0.08)
  content(geo.at(20), text(blue)[$d(x, y)$], anchor: "south", padding: 0.08)
  content(((px.at(0) + py.at(0)) / 2, (px.at(1) + py.at(1)) / 2), box(fill: white, inset: 2pt, text(orange)[$|x - y|$]), anchor: "north", padding: 0.06)
})

// the density sin^(n-1) θ of the area of S^n, θ = angle from the north pole
#let density-fig = cetz.canvas(length: 1.2cm, {
  import cetz.draw: *
  let w = 8
  let h = 2.6
  line((0, 0), (w + 0.4, 0), mark: (end: ">"))
  line((0, 0), (0, h + 0.4), mark: (end: ">"))
  content((w + 0.8, 0), $theta$)
  content((0, -0.45), $0$)
  content((w / 2, -0.5), $pi/2$)
  content((w, -0.45), $pi$)
  for (k, (n, col)) in ((2, blue), (10, green), (100, red)).enumerate() {
    let pts = range(0, 301).map(i => {
      let t = i / 300 * calc.pi
      (t / calc.pi * w, h * calc.pow(calc.sin(t), n - 1))
    })
    line(..pts, stroke: 1.5pt + col)
    content((w + 0.5, h - 0.55 * k), text(col, size: 17pt)[$n = #n$], anchor: "west")
  }
})

// silhouette of a hypersurface of revolution with a thin neck
#let revolution-fig = cetz.canvas(length: 1.5cm, {
  import cetz.draw: *
  let s = 2.2
  let f(t) = calc.sqrt(calc.max(1 - t * t, 0)) * (0.25 + 1.2 * t * t)
  let profile(sign) = range(0, 161).map(i => {
    let t = -1 + 2 * i / 160
    (s * t, sign * s * f(t))
  })
  line((-1.25 * s, 0), (1.3 * s, 0), stroke: (paint: gray, dash: "dashed"), mark: (end: ">"))
  content((1.45 * s, 0), $t$)
  line(..profile(1), stroke: 1.5pt + blue)
  line(..profile(-1), stroke: 1.5pt + blue)
  line((0, -s * f(0)), (0, s * f(0)), stroke: 2pt + orange)
  content((0, -0.68 * s), text(orange)[thin neck], anchor: "north", padding: 0.1)
})

= Introduction


== The phenomenon

*Measure concentration* (P. Lévy, V. Milman): in many high-dimensional spaces,

- a set containing half of the space, made a little bigger, contains almost all of the space;
- equivalently, a function that cannot change fast is almost constant.

*Interactive introduction:* #link("https://cclion61-droid.github.io/mc-interactive-slides/#1")[cclion61-droid.github.io/mc-interactive-slides]

To make this precise we need

+ a notion of *distance*: metric spaces;
+ a notion of *size*: measures;
+ a number that measures concentration: the *concentration function*.

= Metric

== Metric spaces

#definition[
  A *metric* on a set $X$ is a function $d : X times X -> [0, oo)$ such that for all $x, y, z in X$:
  + $d(x, y) = 0 <==> x = y$;
  + $d(x, y) = d(y, x)$;
  + $d(x, z) <= d(x, y) + d(y, z)$ #h(1fr) (triangle inequality).
  The pair $(X, d)$ is a *metric space*.
]

*Example ($RR^1$).* $d(x, y) = |x - y|$. The triangle inequality is $|x - z| <= |x - y| + |y - z|$, and the open ball is $B(x, r) = (x - r, x + r)$.

== Example: the sphere

#grid(
  columns: (1fr, auto),
  gutter: 1em,
  align: horizon,
  [
    On $S^n subset RR^(n+1)$ there are two natural metrics:

    - the *straight-line distance* $|x - y|$, inherited from $RR^(n+1)$;
    - the *geodesic* metric $d(x, y) = arccos chevron.l x, y chevron.r$, the length of the shortest arc of a great circle from $x$ to $y$.

    They are related by $|x - y| = 2 sin(d(x, y)\/2)$, so
    $ 2/pi d(x, y) <= |x - y| <= d(x, y). $
    From now on $S^n$ carries the geodesic metric $d$.
  ],
  sphere-fig,
)

== $r$-neighbourhoods

#definition[
  For $A subset.eq X$ and $r > 0$, let $d(x, A) := inf_(a in A) d(x, a)$ and
  $ A_r := {x in X : d(x, A) < r}. $
]

#grid(
  columns: (1fr, auto),
  gutter: 1em,
  align: horizon,
  [
    - In $RR$: $A = [a, b]$ gives $A_r = (a - r, b + r)$.
    - On $S^n$: the northern hemisphere $A = {x_(n+1) >= 0}$ gives $A_r = {x_(n+1) > -sin r}$: everything except a cap of radius $pi\/2 - r$ around the south pole.
  ],
  hemi-fig,
)

= Measure

== $sigma$-algebras and measures

#definition[
  A *$sigma$-algebra* on $X$ is a collection $cal(F)$ of subsets of $X$ with $emptyset in cal(F)$, closed under complements and countable unions.
]

#definition[
  A *measure* is a map $mu : cal(F) -> [0, oo]$ with $mu(emptyset) = 0$ and
  $ mu(union.big_(i=1)^oo A_i) = sum_(i=1)^oo mu(A_i) quad "for pairwise disjoint" A_i. $
  It is a *probability measure* if $mu(X) = 1$.
]

On a metric space we use the *Borel* $sigma$-algebra: the smallest one containing all open sets. (Not every subset of $RR$ can be given a length.)

== Example: $RR^1$

The *Lebesgue measure* $lambda$ is the length: $lambda([a, b]) = b - a$.

- $lambda({x}) = 0$, hence $lambda(QQ) = sum_(q in QQ) lambda({q}) = 0$ by countable additivity.
- $lambda(RR) = oo$, so $lambda$ is not a probability measure.

A probability measure out of it: the *uniform* measure on $[0, 1]$, $mu(A) = lambda(A inter [0, 1])$.

== Example: the sphere

The *normalised surface measure* $sigma$ on $S^n$: $sigma(A) = "area"(A) \/ "area"(S^n)$.

- It is invariant under rotations: $sigma(U A) = sigma(A)$ for every orthogonal $U$.
- With $theta in [0, pi]$ the angle from the north pole,
  $ sigma({a <= theta <= b}) = (integral_a^b sin^(n-1) theta dif theta) / (integral_0^pi sin^(n-1) theta dif theta). $
- For $n = 2$ this is $(cos a - cos b)\/2$: the area of a band is proportional to its height (Archimedes).

== Metric measure spaces

#definition[
  A *metric measure space* (mm-space) $(X, d, mu)$ is a metric space $(X, d)$ with a Borel probability measure $mu$.
]

Examples:

- $([0, 1], |dot|, lambda)$;
- $(S^n, d, sigma)$ with the geodesic metric and normalised area.

= Example

== Half of an interval and its $r$-neighbourhood

Take $X = [0, 1]$ with $lambda$ and $A = [0, 1\/2]$, so $lambda(A) = 1\/2$. Then $A_r = [0, 1\/2 + r)$ and
$ 1 - lambda(A_r) = 1/2 - r quad (r <= 1\/2). $

On the circle $S^1$, a half circle $A$ gives $1 - sigma(A_r) = 1/2 - r/pi$.

The mass left outside $A_r$ decreases only *linearly* in $r$: no concentration.

== Half of a sphere and its $r$-neighbourhood

$A = {x_(n+1) >= 0}$ has $sigma(A) = 1\/2$, and $S^n without A_r$ is the cap $theta >= pi\/2 + r$:
$ 1 - sigma(A_r) = (integral_(pi\/2 + r)^pi sin^(n-1) theta dif theta) / (integral_0^pi sin^(n-1) theta dif theta). $

#grid(
  columns: (auto, 1fr),
  gutter: 1.5em,
  align: horizon,
  density-fig,
  [
    Near $theta = pi\/2$,
    $ sin^(n-1) theta approx e^(-(n-1)(theta - pi\/2)^2\/2), $
    so almost all mass lies within $approx 1\/sqrt(n)$ of the equator.
  ],
)

== Lévy's inequality

#theorem("Lévy")[
  If $A subset.eq S^n$ is Borel and $C$ is a cap with $sigma(C) = sigma(A)$, then $sigma(A_r) >= sigma(C_r)$ for all $r > 0$.
]

#corollary[
  If $sigma(A) >= 1\/2$, then $1 - sigma(A_r) <= e^(-(n-1) r^2\/2)$ for all $r > 0$.
]

On $S^(1000)$ with $r = 0.1$: $1 - sigma(A_r) <= e^(-4.995) < 0.007$, *whatever* the half $A$ is. Compare $[0, 1]$, where $1 - lambda(A_r) = 0.4$.

= Concentration function

== Definition

#definition[
  The *concentration function* of an mm-space $(X, d, mu)$ is
  $ alpha_mu (r) := sup{1 - mu(A_r) : A subset.eq X "Borel", mu(A) >= 1/2}, quad r > 0. $
]

$alpha_mu$ is non-increasing and $alpha_mu <= 1\/2$; small $alpha_mu (r)$ means strong concentration.

- $([0, 1], lambda)$: $alpha(r) = max(1\/2 - r, 0)$;
- $(S^1, sigma)$: $alpha(r) = max(1\/2 - r\/pi, 0)$;
- $(S^n, sigma)$: $alpha(r) <= e^(-(n-1) r^2\/2)$ (Lévy).

== Lévy families

#definition[
  A sequence of mm-spaces $(X_n, d_n, mu_n)$ is a *Lévy family* if
  $ alpha_(mu_n)(r) -> 0 quad "for every" r > 0. $
]

- $(S^n, d, sigma)$, $n = 1, 2, dots$ is a Lévy family, since $e^(-(n-1) r^2\/2) -> 0$.
- The constant sequence $([0, 1], |dot|, lambda)$ is not: $alpha(r) = 1\/2 - r$ for all $n$.

== Example: a hypersurface of revolution

Rotating a profile $f : [a, b] -> (0, oo)$ about an axis gives
$ Sigma_f := {(t, f(t) u) : t in [a, b], u in S^(n-1)} subset RR^(n+1), $
with the geodesic distance of $Sigma_f$ and the normalised area
$ mu_f prop f(t)^(n-1) sqrt(1 + f'(t)^2) dif t dif u. $

#grid(
  columns: (1fr, auto),
  gutter: 1em,
  align: horizon,
  [
    - $f(t) = sqrt(1 - t^2)$ gives back $S^n$: the density is $(1 - t^2)^((n-2)\/2)$, that is, $sin^(n-1) theta dif theta$.
    - A thin neck splits the mass into two halves: making one of them a little bigger gains almost nothing, so $alpha_(mu_f)(r) approx 1\/2$ for small $r$: no concentration.
  ],
  revolution-fig,
)


= Concentration under measured Gromov–Hausdorff convergence

== The Heisenberg group

On $HH^n = RR^(2n+1)$ with coordinates $(x, y, t)$, $x, y in RR^n$:
$ X_i := partial_(x_i) - y_i/2 partial_t, quad Y_i := partial_(y_i) + x_i/2 partial_t, quad T := partial_t, $
$ Theta := dif t + 1/2 sum_(i=1)^n (y_i dif x^i - x_i dif y^i), quad xi := ker Theta = op("span"){X_i, Y_i}, $
with $[X_i, Y_j] = delta_(i j) T$ and $g$ the sub-Riemannian metric on $xi$ making ${X_i, Y_i}$ orthonormal.

== The sphere in the Heisenberg group

The Euclidean unit sphere $Sigma := S^(2n) = {|x|^2 + |y|^2 + t^2 = 1}$ inherits

- a distribution $cal(H) := xi inter T Sigma$ with the metric $g|_cal(H)$, hence a Carnot–Carathéodory distance $d_"cc"$ (horizontal curves only);
- the p-area measure, normalised: $mu prop sqrt((1 - t^2)(1 + t^2\/4)) dif sigma_0$.

#align(center)[*Question.* What is the concentration function of $Sigma := (S^(2n), d_"cc", mu)$?]

== From sub-Riemannian structure to Riemannian structure

The sub-Riemannian structure on $Sigma$ is too difficult to study directly: it is not a Riemannian manifold, so the usual estimates cannot be applied to it.

But it is a limit of Riemannian ones: for $L > 0$,
$ g_L := sum_i ((dif x^i)^2 + (dif y^i)^2) + L Theta^2, quad |v|_(g_L)^2 = |v_xi|_g^2 + L Theta(v)^2, $
where $v_xi$ is the horizontal part of $v$. Horizontal vectors have $L$-free length; everything transverse to $xi$ is inflated.

On $Sigma$ this gives compact Riemannian mm-spaces $Sigma_L := (S^(2n), d_L^Sigma, mu_L)$, with $d_L^Sigma$ the intrinsic distance of $(Sigma, g_L|_Sigma)$ and $mu_L$ its normalised area. As $L -> oo$:
$ d_L^Sigma arrow.t d_"cc", quad mu_L -> mu. $

== The family

A computation in coordinates $(u, t) in S^(2n-1) times (-1, 1)$, $(x, y) = sqrt(1 - t^2) u$, with $eta := (sum_i (x_i dif y^i - y_i dif x^i))|_(S^(2n-1))$ gives
$ g_L|_Sigma = t^2/(1 - t^2) dif t^2 + (1 - t^2) g_(S^(2n-1)) + L (dif t - 1/2 (1 - t^2) eta)^2, $
$ op("Vol")_(Sigma, g_L) = W dif sigma_0, quad W := sqrt(L (1 - t^2)(1 + t^2\/4) + t^2). $
// the source slide writes Vol_Σ = n! sqrt(...) dσ_0; the n! cancels after normalising, so it is replaced by the limit that defines the p-area
Normalising gives $mu_L prop W dif sigma_0$, and $L^(-1\/2) W -> sqrt((1 - t^2)(1 + t^2\/4))$ gives $mu_L -> mu$. Hence
$ Sigma_L = (S^(2n), d_L^Sigma, mu_L) quad --> quad Sigma = (S^(2n), d_"cc", mu). $

== Measured Gromov–Hausdorff convergence

#definition[
  $f : X -> Y$ is _$epsilon$-isometric_ if
  $ |d_Y (f(x), f(y)) - d_X (x, y)| <= epsilon quad "for all" x, y. $
  Compact mm-spaces $(X_n, d_n, mu_n)$ converge to $(X, d, mu)$ in the _measured Gromov–Hausdorff_ sense if there are Borel $epsilon_n$-isometric maps $f_n : X_n -> X$, $epsilon_n -> 0$, with
  $ nu_n := (f_n)_* mu_n -> mu quad "weakly". $
]

Here $(f_n)_* mu_n (B) := mu_n (f_n^(-1)(B))$, and $nu_n -> mu$ weakly means $integral phi dif nu_n -> integral phi dif mu$ for every continuous $phi : X -> RR$.

== Question

$Sigma_L -> Sigma$ is exactly measured Gromov–Hausdorff convergence. So:

#align(center)[*Is the concentration function $alpha$ continuous along mGH convergence?*]

*Result.* For $alpha := alpha_mu$, $alpha_n := alpha_(mu_n)$ and $alpha(r^(plus.minus)) := lim_(s -> r^(plus.minus)) alpha(s)$:
$ alpha(r^(+)) <= liminf_(n -> oo) alpha_n (r) <= limsup_(n -> oo) alpha_n (r) <= alpha(r^(-)), quad r > 0. $
The last inequality is unconditional; the first needs one hypothesis.

== What weak convergence gives --- and what it does not

#theorem("Portmanteau")[
  $ nu_n -> mu "weakly" & <==> liminf_n nu_n (U) >= mu(U) "for open" U \
    & <==> limsup_n nu_n (F) <= mu(F) "for closed" F. $
]

Not obvious: $alpha_mu (r) = sup{1 - mu(A_r) : mu(A) >= 1/2}$ is a supremum over all Borel sets, the threshold is pinned at $1/2$, and weak convergence controls open sets in one direction only.

#theorem("Ledoux")[
  If $mu(A) >= theta > 0$ and $alpha_mu (r_0) < theta$, then $1 - mu(A_(r_0 + r)) <= alpha_mu (r)$ for every $r > 0$.
]

A threshold $theta < 1/2$ is converted back to $1/2$, at the cost of a shift $r_0$.

== The upper bound: unconditional

#lemma("[Chen, Group 5]")[
  For every $r > 0$ and every $u in (0, r)$,
  $ limsup_(n -> oo) alpha_n (r) <= alpha(u), quad "hence" quad limsup_(n -> oo) alpha_n (r) <= alpha(r^(-)). $
]

No hypothesis on the above inequality.

#proof[
  Almost optimal sets $A^((n)) subset.eq X_n$ have images $f_n (A^((n)))$ that need not be Borel, and need not converge. Replace them by the closed sets $C_n := cl(f_n (A^((n))))$ and use Blaschke's selection theorem: $(cal(F)(X), d_H)$ is compact, so $C_n -> C$ in Hausdorff distance along a subsequence. Portmanteau on the closed $cl(C_eta)$ gives $mu(C) >= 1/2$; Portmanteau on the open $C_u$ finishes.
]

Compactness of the _limit_ space is used here, and again in the gap proposition below.

== The lower bound

#lemma("[Chen, Group 5]")[
  #set enum(numbering: "(a)")
  Fix $r > 0$, $0 < epsilon < 1/2$; let $A subset.eq X$ be open with $mu(A) >= 1/2$ and $B := f_n^(-1)(A)$. If
  + $d > 1$ with $r \/ (r - epsilon_n) < d$;
  + $nu_n (A) >= mu(A) - epsilon$ and $nu_n (cl(A_r)) <= mu(cl(A_r)) + epsilon$ #h(1fr) (true for large $n$)
  + $r_n > 0$ with $alpha_n (r_n) < 1/2 - epsilon$ and $r\/d - r_n > 0$,
  then
  $ 1 - mu(cl(A_r)) <= alpha_n (r\/d - r_n) + epsilon. $
]

== Reading the lower bound

(a) absorbs the isometry defect; (c) is Ledoux's lemma applied _inside_ $X_n$, with threshold $1/2 - epsilon$; the mass defect $epsilon$ enters additively. Nothing is asymptotic yet.

#corollary("[Chen, Group 5]")[
  For $r > 0$, $0 < epsilon < 1/2$ there is $N$ with $alpha(r^(+)) <= alpha_n (r\/d - r_n) + 2 epsilon$ for all $n >= N$ and all admissible $d, r_n$.
]

== The hypothesis: no asymptotic flatness at level $1\/2$

Everything hinges on whether the Ledoux radius $r_n$ can be taken small. Put
$ rho_n (epsilon) := inf{s > 0 : alpha_n (s) < 1/2 - epsilon}, quad rho(epsilon) := limsup_n rho_n (epsilon). $

#hypothesis("NF")[
  $lim_(epsilon arrow.b 0) rho(epsilon) = 0$; equivalently, $limsup_(n -> oo) alpha_n (s) < 1/2$ for every $s > 0$.
]

A criterion on the limit space alone: $alpha(s) < 1/2$ for all $s > 0 ==>$ (NF).

#proposition[
  If $alpha_mu (s) = 1/2$ for some $s > 0$, then $supp mu subset.eq F union G$ with $F, G$ disjoint, non-empty, closed, $d(F, G) >= s\/2$ and $mu(F) = mu(G) = 1/2$. Hence $supp mu$ connected $==>$ (NF).
]

== The convergence theorem

#theorem("[Chen, Group 5]")[
  Assume (NF). Then for every $r > 0$
  $ alpha(r^(+)) <= liminf_(n -> oo) alpha_n (r) <= limsup_(n -> oo) alpha_n (r) <= alpha(r^(-)). $
  Consequently $alpha_n (r) -> alpha(r)$ at every continuity point $r$ of $alpha$, hence for all but countably many $r > 0$.
]

#proof[
  Right inequality: the upper bound. Left: at radius $v > u$ choose $d_n arrow.b 1$ (possible since $epsilon_n -> 0$) and $r_n$ near $rho(epsilon)$ (small by (NF)), so that $v\/d_n - r_n > u$; then the corollary to the lower bound and monotonicity give $alpha(v^(+)) <= alpha_n (u) + 2 epsilon$. Let $epsilon arrow.b 0$, then $v arrow.b u$.
]

== The conclusion

// TODO: the source slide also states δ_L ≤ c_n L^(-1/2), but δ_L is never defined there, so it is left out
#example("The sub-Riemannian sphere")[
  Let $n >= 2$ and $L -> oo$. Then $Sigma_L -> Sigma$ in the measured Gromov–Hausdorff sense, with $epsilon_L = epsilon_L^Sigma arrow.b 0$. Since $supp mu = Sigma$ is connected, the gap proposition gives (NF) and the convergence theorem gives
  $ alpha_(Sigma_L)(r) --> alpha_Sigma (r) quad (L -> oo) $
  at every continuity point of $alpha_Sigma$, hence for all but countably many $r > 0$.
]
