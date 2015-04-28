apt-get -y install vim
apt-get -y install unzip

ssh-keygen -t rsa -P ''
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

em /opt
wget http://ftp.unicamp.br/pub/apache/hadoop/common/hadoop-1.2.1/hadoop-1.2.1.tar.gz
tar xvfz hadoop-1.2.1.tar.gz
rm hadoop-1.2.1.tar.gz
export JAVA_HOME="/usr/lib/jvm/java-7-oracle"
export HADOOP_PREFIX="/opt/hadoop-1.2.1"
export HADOOP_CONF_DIR=$HADOOP_PREFIX/conf
export PATH=$HADOOP_PREFIX/bin:$PATH

vim /opt/hadoop-1.2.1/conf/core-site.xml
add

<configuration>
        <property>
                <name>fs.default.name</name>
                <value>hdfs://localhost:9000</value>
        </property>
</configuration>

vim /opt/hadoop-1.2.1/conf/hadoop-env.sh
add
export JAVA_HOME="/usr/lib/jvm/java-7-oracle"

hadoop namenode -format

start-all.sh

em /opt
wget http://ftp.unicamp.br/pub/apache/mahout/0.9/mahout-distribution-0.9.tar.gz

tar xvfz mahout-distribution-0.9.tar.gz
rm mahout-distribution-0.9.tar.gz

em ~/
wget http://www.grouplens.org/system/files/ml-100k.zip
unzip ml-100k.zip
rm ml-100k.zip

em ~/ml-100k
hadoop fs -put u.data u.data

hadoop jar /opt/mahout-distribution-0.9/mahout-core-0.9-job.jar org.apache.mahout.cf.taste.hadoop.item.RecommenderJob -s SIMILARITY_COOCCURRENCE --input u.data --output output

hadoop fs -getmerge output output.txt

python show_recommendations.py 4 u.data u.item output.txt
