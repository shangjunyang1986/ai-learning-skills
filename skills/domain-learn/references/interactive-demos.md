# Interactive demos — the highest-value part of a domain page

For a visual or algorithmic topic, one well-made interactive demo teaches more than ten
paragraphs. It's what makes a `domain-learn` page special. But a forced, meaningless widget
is worse than nothing — so build one **only when the topic has a clean core intuition you
can make tangible**, and skip it (say so) otherwise.

## When a demo fits
- The topic has a **visual or geometric** core (rendering, graphics, simulation, geometry).
- Or an **algorithmic** core you can animate/parameterize (search, sampling, optimization,
  sorting, diffusion steps, attention weights).
- The core idea has a **knob**: something the learner can change and immediately see the
  effect of (count, scale, step, temperature, learning rate, threshold).

## When to skip
- Purely conceptual/qualitative topics with no clean visual (e.g. "the history of X",
  "ethics of Y"). Don't bolt on a fake slider. Note that the topic is better served by
  diagrams/text.

## Hard requirements (every demo)
- **Fully self-contained & offline.** Inline `<canvas>`/SVG/WebGL + JS in the single HTML
  file. **No external data, no CDN, no network.** It must work from a double-clicked file.
- **Teaches ONE concept.** Don't build a mini-app; isolate the single intuition.
- **Has controls + live feedback.** Sliders/buttons that change something visible, ideally
  with a readout (a number, a similarity %, a step counter) so the learner sees cause→effect.
- **Robust.** Deterministic enough to not flicker; no console errors; reasonable performance
  (render on input, not a 60fps loop unless the concept needs animation).
- **Honest framing.** A one-line caption stating what's simplified vs the real thing ("this
  is a 2D teaching simplification; the real method is 3D / differentiable / …").

## Demo archetypes (pick the one that fits)
- **Parameter playground** — vary N / size / temperature and watch the output change.
  *(3DGS example: place N anisotropic 2D gaussians, alpha-blend toward a target; sliders for
  count and size; live "reconstruction similarity %". Teaches density-vs-detail.)*
- **Before/after slider** — drag a divider between two states (raw vs processed, on vs off).
- **Step-through** — a "next step" button that advances an algorithm one iteration, drawing
  the state (great for search, sampling, diffusion denoising, gradient descent).
- **Small simulation** — a handful of interacting elements the user can perturb.

## Implementation notes
- The bundled `template.html` already contains the **2D Gaussian Splatting playground** as a
  worked pattern: an offscreen "ground-truth" canvas, a seeded RNG for reproducible
  scatter, anisotropic radial-gradient splats, alpha compositing, and a pixel-diff
  similarity readout. Adapt this scaffold (the `.demo` markup + its IIFE in the script) to
  your topic rather than starting from scratch.
- Keep the control panel in the `.ctrl` box; keep the canvas crisp on a dark background.
- Compute any "score" cheaply (sample a subset of pixels) so dragging a slider stays smooth.
- Seed randomness from a counter you bump on a "regenerate" button — never `Math.random()`
  at module load (keeps it reproducible and avoids surprising the learner).

## The test
Would a smart beginner, after 30 seconds of dragging the slider, *get* the core idea they
couldn't get from the prose? If yes, ship it. If you can't honestly say yes, cut it.
