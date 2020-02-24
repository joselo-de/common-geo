from flask import Flask, render_template, request, jsonify
app = Flask(__name__)


# landing page with site explanation
@app.route('/', methods=['GET', 'POST'])
def home():
    return render_template('home.html')


# pick a country and you'll see detailed information
#@app.route('/pick_country/', methods=['GET','POST'])
#def pick_country():
#    return render_template('pick_country.html', states=state_list)


# page showing the rankings of best and worst counties in terms of secure vs insecure websites
@app.route('/rankings/', methods=['GET', 'POST'])
def rankings():
    return render_template('rankings.html')


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False, threaded=True)
