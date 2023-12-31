import { createSlice } from "@reduxjs/toolkit";
import { createAsyncThunk } from "@reduxjs/toolkit";
import axios from "axios";

const USERS_URL = 'https://jsonplaceholder.typicode.com/users'

const initialState = []

export const fetchUsers = createAsyncThunk('users/fetchUsers', async() => {
    try {
        const response = await axios.get(USERS_URL);
        return response.data;
    } catch(err) {
        return err.message;
    }
})

const userSlice = createSlice({
    name: 'users',
    initialState,
    reducers: {},
    extraReducers(builder) {
        builder.addCase(fetchUsers.fulfilled, (state, action) => {
            //action.payload ngambil dari return nya fetchUsers
            return action.payload;//mengganti seluruh state dengan action.payload
        })
    }
})

export const selectAllUsers = (state) => state.users
export default userSlice.reducer