try:
    import unittest
    from app import app
    from dotenv import load_dotenv
    load_dotenv()

except Exception as e:
    print("Missing modules {}".format(e))


class FlaskAppTest(unittest.TestCase):

    def setUp(self):
        # set up test client
        self.app = app.test_client(self)
        self.app.testing = True

    def test_home_page(self):
        # send a GET request to the home page
        result = self.app.get('/')
        # check that the status code is 200 (OK)
        self.assertEqual(result.status_code, 200)
        # check that the response content contains the expected message
        # self.assertIn(b'Hello, World!', result.data)

#    def test_not_found_page(self):
        # send a GET request to a non-existing page
#        result = self.app.get('/page-not-found')
        # check that the status code is 404 (Not Found)
#        self.assertEqual(result.status_code, 404)
        # check that the response content contains the expected message
#        self.assertIn(b'Page Not Found', result.data)

if __name__ == '__main__':
    unittest.main()
