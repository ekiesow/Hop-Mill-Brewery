FROM rust:buster

RUN apt-get update && apt-get upgrade -y
RUN apt-get install vim git -y

# create a default cargo project to complete the setup
#RUN cd /home && export USER=root && cargo new hop-mill --bin
RUN mkdir /hop-mill
ADD . /hop-mill
WORKDIR /hop-mill/hop-mill
RUN cd /hop-mill/hop-mill

# configs for using rocket.rs
RUN rustup default nightly
RUN rustup override set nightly
RUN cargo install cargo-watch

# install wasm-pack
RUN curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh 
RUN cargo install cargo-generate

# update rust packages
RUN rustup update && cargo update

# add rocket dependency
RUN echo "rocket = \"0.4.5\"" >> /hop-mill/hop-mill/Cargo.toml

# build the Rocket server dependencies
#RUN cargo build

# copy shell script to run cargo and make script an executable
COPY ./hop-mill/run.sh /hop-mill/
RUN chmod +x /hop-mill/run.sh

# configures a container that will run as an executable
#ENTRYPOINT ["tail", "-f", "/dev/null"]
ENTRYPOINT ["./run.sh"]
