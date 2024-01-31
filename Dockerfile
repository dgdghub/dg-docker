FROM python:3.8.3

# 定义编码
ENV LC_ALL="C.UTF-8" LANG="C.UTF-8"
ENV PYTHONIOENCODING=utf-8

# Update timzone of container
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 定义工作目录
RUN mkdir -p /opt/app/feynman-paqs
WORKDIR /opt/app/feynman-paqs
RUN pip install -i https://mirrors.aliyun.com/pypi/simple --upgrade pip
# 更换源
# RUN sed -i "s/archive.ubuntu./mirrors.aliyun./g" /etc/apt/sources.list
# RUN sed -i "s/deb.debian.org/mirrors.aliyun.com/g" /etc/apt/sources.list
# RUN sed -i "s/security.debian.org/mirrors.aliyun.com\/debian-security/g" /etc/apt/sources.list
# RUN sed -i "s/httpredir.debian.org/mirrors.aliyun.com\/debian-security/g" /etc/apt/sources.list

# # 更换pip源
# RUN pip install -i https://mirrors.aliyun.com/pypi/simple --upgrade pip
# RUN pip config set global.index-url http://mirrors.aliyun.com/pypi/simple
# RUN pip config set install.trusted-host mirrors.aliyun.com
# RUN cd /etc/apt
# RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
# RUN echo "deb https://mirrors.ustc.edu.cn/debian/ stretch main contrib non-free" >> /etc/apt/sources.list
# RUN echo "deb-src https://mirrors.ustc.edu.cn/debian/ stretch main contrib non-free" >> /etc/apt/sources.list
# RUN echo "deb https://mirrors.ustc.edu.cn/debian/ stretch-updates main contrib non-free" >> /etc/apt/sources.list
# RUN echo "deb-src https://mirrors.ustc.edu.cn/debian/ stretch-updates main contrib non-free" >> /etc/apt/sources.list
# RUN echo "deb https://mirrors.ustc.edu.cn/debian/ stretch-backports main contrib non-free" >> /etc/apt/sources.list
# RUN echo "deb-src https://mirrors.ustc.edu.cn/debian/ stretch-backports main contrib non-free" >> /etc/apt/sources.list
# RUN echo "deb https://mirrors.ustc.edu.cn/debian-security/ stretch/updates main contrib non-free" >> /etc/apt/sources.list
# RUN echo "deb-src https://mirrors.ustc.edu.cn/debian-security/ stretch/updates main contrib non-free" >> /etc/apt/sources.list

# 设置环境变量
ENV serverName=""
ENV PATH=$PATH:/opt/app/feynman-paqs
ENV PYTHONPATH /opt/app/feynman-paqs
COPY . .

ARG DEBIAN_FRONTEND=noninteractive

RUN sed -i s@/deb.debian.org/@/mirrors.aliyun.com/@g /etc/apt/sources.list \
    && apt-get clean \
    && apt-get update && apt-get install --assume-yes apt-utils \
    && apt install -y rpm alien \
    && alien util/rocketmq-client-cpp-2.0.0-centos7.x86_64.rpm \
    && dpkg -i rocketmq-client-cpp_2.0.0-1_amd64.deb \
    && ln -s /usr/local/lib/librocketmq.so /usr/lib \
    && ldconfig 
VOLUME ["/opt/logs"]
# RUN apt-get update
# RUN apt-get install -y rpm alien
# RUN alien mq/rocketmq-client-cpp-2.0.0-centos7.x86_64.rpm
# RUN dpkg -i rocketmq-client-cpp_2.0.0-1_amd64.deb
# RUN ln -s /usr/local/lib/librocketmq.so /usr/lib
# RUN ldconfig 

# RUN pip install -r requirements.txt --upgrade --default-timeout=1000
RUN pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple --upgrade --default-timeout=1000
# RUN pip install permanent
# CMD python server/$serverName
# ENTRYPOINT ["python","server/$serverName"]