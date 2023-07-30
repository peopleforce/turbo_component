FROM ruby:3.1.4
RUN apt-get update -qq --fix-missing && \
    apt-get install -y build-essential libpq-dev pkg-config glib2.0-dev libexpat1-dev software-properties-common tmux

# Install nodejs
ENV NODE_VERSION=18.16.0
RUN apt install -y curl
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"

# Install Yarn
RUN npm install -g yarn

WORKDIR /usr/src/app

RUN echo "gem: --no-document" >> ~/.gemrc
RUN gem update --system
RUN gem install bundler

RUN gem install foreman
RUN yarn install

COPY Gemfile Gemfile.lock .ruby-version ./

COPY package.json yarn.lock ./

# Copy the main application.
COPY . ./

CMD ["bundle", "exec", "rails", "server", "--binding=0.0.0.0", "--port=3000"]