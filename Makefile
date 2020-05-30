container_name = preview-twno

up:
	docker run --rm -d --name $(container_name) -p 8080:80 -v "$$PWD":/usr/local/apache2/htdocs/ httpd:2.4

down:
	docker stop $(container_name)

gen:
	for xx in data1 data2; do (cd $$xx; bash make.sh);done
