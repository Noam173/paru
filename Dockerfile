FROM archlinux:base-devel AS build-stage

ARG DIR=/paru
ARG RUST_VER=nightly

RUN pacman -Syu --noconfirm

RUN pacman -S rustup sudo --noconfirm

RUN echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN useradd -m user

RUN usermod -aG wheel user

WORKDIR ${DIR}

COPY . .

RUN chown -R user:user ${DIR}

USER user

RUN rustup default ${RUST_VER}

RUN cargo build --release

FROM scratch AS export-stage
COPY --from=build-stage /paru/target/release/paru /
