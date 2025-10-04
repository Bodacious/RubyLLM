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

## Talk structure

- [ ] Header slide
- [ ] Introductions
- [ ] Really simple unigram example

  - Demonstrate the principle of computing the statistical structure of a sample of text
  - Demonstrate how text can be broken up into individual "tokens"
- [ ] Cleaned up unigram example
  - [ ] Make the code cleaner, so that it's easier to abstract bits later
- [ ] Bigram model 
  - Introduce the idea of context. That if we want to get something meaningful back from a
    model then we have to give it a more specific context to work within.
  - Probability distributions are now calculated based on their context, rather than their total probability
- [ ] Add BOS and EOS, special tokens with semantic meaning, that aren't necessarily words, but teach the model where text should probably begin and end
- [ ] Extend bigram to trigram
- [ ] Introduce larger corpus
  - Demonstrate that the context size (n) becomes a limitation, because of the memory and training data required.
- [ ] Tokenize the tokens
  - We can use this to generate probabalistic content for other media types as well
- [ ] Add sampling
  - Discuss temperature, and how sampling can be used to generate unique content
- This was what language models were for decades

- Neural networks.
  - What new innovation do neural nets bring?  
  - Discuss the benefits brought by neural networks
  - Discuss the limitations (context again?)

- LLMs 
  - Attention
  - This time the context constraint is the size of the QKV matrices
