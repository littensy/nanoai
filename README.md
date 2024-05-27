<p align="center">
  <p align="center">
	<img width="150" height="150" src="https://raw.githubusercontent.com/littensy/charm/master/images/logo.png" alt="Logo">
  </p>
  <h1 align="center"><b>Nanoai</b></h1>
  <p align="center">
    Minimal library for creating neural networks.
    <br />
    <a href="https://npmjs.com/package/@rbxts/nanoai"><strong>npm package →</strong></a>
  </p>
</p>

<div align="center">

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/littensy/nanoai/ci.yml?style=for-the-badge&branch=master&logo=github)
[![NPM Version](https://img.shields.io/npm/v/@rbxts/nanoai.svg?style=for-the-badge&logo=npm)](https://www.npmjs.com/package/@rbxts/nanoai)
[![GitHub License](https://img.shields.io/github/license/littensy/nanoai?style=for-the-badge)](LICENSE.md)

</div>

**Nanoai** is a fast, lightweight library for handling multi-layer perceptron (MLP) neural networks.

The addition of recurrent and convolutional layers is not planned at this time.

## 📦 Setup

### TypeScript

```sh
npm install @rbxts/nanoai
yarn add @rbxts/nanoai
pnpm add @rbxts/nanoai
```

### Wally

Add `littensy/nanoai` to your `wally.toml` file.

```toml
[dependencies]
Nanoai = "littensy/nanoai@VERSION"
```

## 📚 API Reference

#### `create(shape, activation)`

#### `predict(network, input)`

#### `backpropagate(network, input, expected, learningRate)`

#### `evolution(options)`

#### `init[type](network, ...)`

#### `initialize(network, initializer)`

#### `clone(network)`

## 🚀 Examples

### XOR problem

```ts
const model = Nanoai.create([2, 3, 1], Activation.TanH);

Nanoai.init.normal(model);

for (const _ of $range(1, 500)) {
	Nanoai.backpropagate(model, [0, 1], [1], 0.3);
	Nanoai.backpropagate(model, [1, 0], [1], 0.3);
	Nanoai.backpropagate(model, [0, 0], [0], 0.3);
	Nanoai.backpropagate(model, [1, 1], [0], 0.3);
}

Nanoai.predict(model, [0, 1]); // ~1
```

---

<p align="center">
Nanoai is released under the <a href="LICENSE.md">MIT License</a>.
</p>

<div align="center">

[![MIT License](https://img.shields.io/github/license/littensy/nanoai?style=for-the-badge)](LICENSE.md)

</div>
