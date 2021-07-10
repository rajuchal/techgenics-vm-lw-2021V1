echo " Installing Confluent Kafka Connector "
echo " Installing Confluent Kafka Datagen Connector "
/home/vagrant/bigdata/confluent/bin/confluent-hub install --no-prompt confluentinc/kafka-connect-datagen:latest
echo " Installation Completed of  Confluent Kafka Datagen Connector "

echo " Installing Confluent Kafka JDBC Source/Sink Connector "
/home/vagrant/bigdata/confluent/bin/confluent-hub install --no-prompt confluentinc/kafka-connect-jdbc:10.2.0
echo " Installation Completed of  JDBC Source/Sink Connector "

echo " Installing Confluent Kafka HDFS3 Sink Connector "
/home/vagrant/bigdata/confluent/bin/confluent-hub install --no-prompt confluentinc/kafka-connect-hdfs3:1.1.1
echo " Installation Completed of  HDFS3 Sink Connector "

echo " Installing Confluent Kafka Debezium Source Connector "
/home/vagrant/bigdata/confluent/bin/confluent-hub install --no-prompt debezium/debezium-connector-mysql:1.5.0
echo " Installation Completed of  Debezium Source Connector "

echo " Installing Confluent Kafka Cassandra Sink Connector "
/home/vagrant/bigdata/confluent/bin/confluent-hub install --no-prompt confluentinc/kafka-connect-cassandra:2.0.0
echo " Installation Completed of  Cassandra Sink Connector "

echo " Installing Confluent Kafka MongoDB Source/Sink Connector "
/home/vagrant/bigdata/confluent/bin/confluent-hub install --no-prompt mongodb/kafka-connect-mongodb:1.5.1
echo " Installation Completed of  MongoDB Source/Sink Connector "