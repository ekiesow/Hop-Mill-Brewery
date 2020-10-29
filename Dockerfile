FROM rust:buster

RUN apt-get update && apt-get upgrade -y
RUN apt-get install vim git -y

# create a default cargo project to complete the setup
RUN cd /home && export USER=root && cargo new hop-mill --bin
WORKDIR /home/hop-mill

# configs for using rocket.rs
RUN rustup default nightly
RUN rustup override set nightly

# update rust packages
RUN rustup update && cargo update

# add rocket dependency
RUN echo "rocket = \"0.4.5\"" >> /home/hop-mill/Cargo.toml

# copy default Rocket server (replaces existing main.rs)
COPY ./hop-mill/src/main.rs /home/hop-mill/src/main.rs

# build the Rocket server dependencies
RUN cargo build

# copy Rocket default settings (req to set Docker-compliant host)
COPY ./hop-mill/Rocket.toml /home/hop-mill/Rocket.toml

# copy shell script to run cargo and make script an executable
COPY ./hop-mill/run.sh /home/hop-mill
RUN chmod +x /home/hop-mill/run.sh

# configures a container that will run as an executable
ENTRYPOINT ["/home/hop-mill/run.sh"]