# hadoop
<pre>
sudo docker build -t <instance_name> .
sudo docker run -d -P --name <instance_name> <instance_name>
sudo docker port <instance_name>
ssh root@localhost -p <ssh_port>
stop-all.sh
hadoop namenode -format
start-all.sh
cd /root/ml-100k
hadoop fs -put u.data u.data
hadoop jar /opt/mahout-distribution-0.9/mahout-core-0.9-job.jar org.apache.mahout.cf.taste.hadoop.item.RecommenderJob -s SIMILARITY_COOCCURRENCE --input u.data --output output
hadoop fs -getmerge output output.txt
python show_recommendations.py <user_id> u.data u.item output.txt

# This archive contains:
# u.data: contains several tuples(user_id, movie_id, rating, timestamp)
# u.user: contains several tuples(user_id, age, gender, occupation, zip_code)
# u.item: contains several tuples(movie_id, title, release_date, video_release_data, imdb_url, cat_unknown, cat_action, cat_adventure, cat_animation, cat_children, cat_comedy, cat_crime, cat_documentary, cat_drama, cat_fantasy, cat_film_noir, cat_horror, cat_musical, cat_mystery, cat_romance, cat_sci_fi, cat_thriller, cat_war, cat_western)
</pre>
