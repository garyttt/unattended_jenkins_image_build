download_awscli_v2 () 
{ 
    AWSCLI_V2_ZIP_FILE="awscliv2.zip";
    AWSCLI_V2_URL="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip";
    curl -L ${AWSCLI_V2_URL} -o ${AWSCLI_V2_ZIP_FILE};
    echo "Un-zipping awscli v2 files...";
    unzip -oq ${AWSCLI_V2_ZIP_FILE};
    rm -f ${AWSCLI_V2_ZIP_FILE}
}
install_awscli_v2 () 
{ 
    download_awscli_v2;
    AWSCLI_V2_BIN="aws";
    echo "Compiling and installing awscli v2 files...";
    ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update;
    rm -rf ./aws
}
install_awscli_v2
rm -rf ./aws
