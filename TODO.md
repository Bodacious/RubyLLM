# TODO
- [ ] Next-token prediction (what an LM does)
  - [X] Working model with a Unigram - no sampling
- [X] Context length with n-grams (uni→bi→tri)
  - [X] include BOS/EOS and “corpus”
  - [X] Bigram model with no sampling
  - [X] Trigram model with no sampling
  - [ ] Add some sampling to make it more interesting
- [ ] Tokenisation (words→tokens)
  - [X] Add spaces as a token
- [X] Probability distributions (show next_probs)
- [ ] Sampling strategies (greedy, temperature, top-k, top-p)
- [ ] Perplexity (lower = better)
- [ ] Limits of n-grams (sparsity, fixed window)
- [ ] Embeddings (words as vectors)
- [ ] Transformers (stacks of attention → LLMs)
- [ ] Self-attention (intuitive heatmap; causal mask)

Demos to build in Ruby:
- [ ] Simple unigram generation
- [ ] Bigram/trigram predictions and generation
- [ ] Sampling variants side-by-side
- [ ] Perplexity on train vs hold-out
- [ ] (Optional) tiny self-attention with a toy heatmap
