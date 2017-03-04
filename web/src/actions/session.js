import { reset } from 'redux-form';
import { Socket } from 'phoenix'; // new line
import api from '../api';
import { fetchUserRooms } from './rooms';

const API_URL = process.env.REACT_APP_API_URL; // new line
const WEBSOCKET_URL = API_URL.replace(/(https|http)/, 'ws').replace('/api', ''); // new line

// new function
function connectToSocket(dispatch) {
  const token = JSON.parse(localStorage.getItem('token'));
  const socket = new Socket(`${WEBSOCKET_URL}/socket`, {
    params: { token },
    logger: (kind, msg, data) => { console.log(`${kind}: ${msg}`, data); }
  });
  socket.connect();
  dispatch({ type: 'SOCKET_CONNECTED', socket });
}

function setCurrentUser(dispatch, response) {
  localStorage.setItem('token', JSON.stringify(response.meta.token));
  dispatch({ type: 'AUTHENTICATION_SUCCESS', response });
  dispatch(fetchUserRooms(response.data.id));
  connectToSocket(dispatch); // new line
}

export function authenticate() {
  return (dispatch) => {
    dispatch({ type: 'AUTHENTICATION_REQUEST' });
    return api.post('/sessions/refresh')
      .then((response) => {
        setCurrentUser(dispatch, response);
      })
      .catch(() => {
        localStorage.removeItem('token');
        window.location = '/login';
      });
  };
}

export const unauthenticate = () => ({ type: 'AUTHENTICATION_FAILURE' });