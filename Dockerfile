FROM circleci/android:api-29-ndk
MAINTAINER dexter@newlogic.com

COPY protoc $HOME/bin/
COPY lcov_cobertura.py $HOME/bin/

ENV PATH=$HOME/bin:$HOME/node-v14.18.3-linux-x64/bin:$PATH
ENV API_LEVEL 23
ENV project $HOME/project/
ENV build $project/build/
ENV dependencies $project/dependencies/
ENV platform android-$API_LEVEL
ENV toolchain $HOME/toolchain/

ENV TOOLCHAIN_FILE $ANDROID_NDK_HOME/build/cmake/android.toolchain.cmake

WORKDIR $HOME

RUN mkdir $toolchain && sudo apt-get update

RUN sudo apt-get install -y cmake autoconf libtool libtool-bin vim \
    libfontconfig1 libxrender1 libxrender1 libxtst6 libxi6 lcov python3-distutils \
    && wget https://nodejs.org/dist/latest-v14.x/node-v14.18.3-linux-x64.tar.gz \
    && tar xvzpf node-v14.18.3-linux-x64.tar.gz \
    && rm -f node-v14.18.3-linux-x64.tar.gz

RUN $ANDROID_NDK_HOME/build/tools/make-standalone-toolchain.sh \
    --arch=arm \
    --platform=$platform \
    --toolchain=arm-linux-android-clang5.0 \
    --install-dir=$toolchain/$platform.armeabi-v7a \
    --use-llvm \
    --stl=libc++ \
    && $ANDROID_NDK_HOME/build/tools/make-standalone-toolchain.sh \
    --arch=arm64 \
    --platform=$platform \
    --toolchain=arm-linux-android-clang5.0 \
    --install-dir=$toolchain/$platform.arm64-v8a \
    --use-llvm \
    --stl=libc++ \
    && $ANDROID_NDK_HOME/build/tools/make-standalone-toolchain.sh \
    --arch=x86 \
    --platform=$platform \
    --toolchain=arm-linux-android-clang5.0 \
    --install-dir=$toolchain/$platform.x86 \
    --use-llvm \
    --stl=libc++ \
    && $ANDROID_NDK_HOME/build/tools/make-standalone-toolchain.sh \
    --arch=x86_64 \
    --platform=$platform \
    --toolchain=arm-linux-android-clang5.0 \
    --install-dir=$toolchain/$platform.x86_64 \
    --use-llvm \
    --stl=libc++
