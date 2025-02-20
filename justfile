alias b := build
alias l := lint
alias t := test
alias tc := test-coverage

build:
    cargo check
    cargo build
    cargo build --release

build-local:
    just build
    sudo cp target/release/hitt /usr/local/bin/hitt-local

format:
    yamlfix .
    yamlfmt .
    just --fmt --unstable .
    mdsf format .
    npx prettier --write --cache .
    cargo fmt

lint:
    cargo fmt -- --check --color always
    cargo clippy --all-targets --all-features -- -D warnings

test:
    just lint
    RUST_BACKTRACE=full cargo test --release

test-coverage:
    cargo llvm-cov clean --workspace
    cargo llvm-cov --all-features --workspace --lcov --output-path lcov.info
    cargo llvm-cov --open

precommit:
    cargo clean
    just format
    just build
    just lint
    just test
    typos .

publish-crates:
    just build
    just test

    cargo publish -p hitt-formatter
    cargo publish -p hitt-parser
    cargo publish -p hitt-request
    cargo publish -p hitt
