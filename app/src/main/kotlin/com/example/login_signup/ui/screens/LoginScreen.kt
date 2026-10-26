package com.example.login_signup.ui.screens

import androidx.compose.foundation.Image
import androidx.compose.ui.draw.clip
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.OutlinedTextFieldDefaults
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.SpanStyle
import androidx.compose.ui.text.buildAnnotatedString
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.text.withStyle
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.login_signup.R
import com.example.login_signup.data.AuthService
import com.example.login_signup.ui.theme.BlueAccent
import com.example.login_signup.ui.theme.GrayBackground
import kotlinx.coroutines.launch

@Composable
fun LoginScreen(
    onNavigateToSignup: () -> Unit,
    onNavigateToForgotPassword: () -> Unit,
    onLoginSuccess: (String) -> Unit
) {
    val snackbarHostState = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()
    val authService = remember { AuthService() }

    var email by remember { mutableStateOf("") }
    var password by remember { mutableStateOf("") }
    var isLoading by remember { mutableStateOf(false) }

    fun isValidEmail(target: String): Boolean {
        return target.contains("@") && target.contains(".")
    }

    fun handleLogin() {
        if (!isValidEmail(email)) {
            scope.launch {
                snackbarHostState.showSnackbar("Please enter a valid email address")
            }
            return
        }

        isLoading = true
        scope.launch {
            val success = authService.login(email.trim(), password)
            isLoading = false
            if (success) {
                snackbarHostState.showSnackbar("Login successful")
                onLoginSuccess(email.trim())
            } else {
                snackbarHostState.showSnackbar("Login failed. Check your credentials.")
            }
        }
    }

    Scaffold(
        snackbarHost = { SnackbarHost(snackbarHostState) },
        containerColor = Color.White
    ) { paddingValues ->
        Box(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues),
            contentAlignment = Alignment.Center
        ) {
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .widthIn(max = 480.dp)
                    .verticalScroll(rememberScrollState())
                    .padding(horizontal = 24.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Spacer(modifier = Modifier.height(24.dp))

                Image(
                    painter = painterResource(id = R.drawable.app_logo),
                    contentDescription = "Chitral Shop Logo",
                    modifier = Modifier
                        .size(80.dp)
                        .clip(androidx.compose.foundation.shape.CircleShape)
                )

                Spacer(modifier = Modifier.height(12.dp))

                Text(
                    text = "Chitral Shop",
                    fontSize = 26.sp,
                    fontWeight = FontWeight.Bold,
                    color = Color(0xFF0F172A)
                )

                Text(
                    text = "By Rahmat • Multi-Vendor Marketplace",
                    fontSize = 12.sp,
                    fontWeight = FontWeight.SemiBold,
                    color = Color(0xFF2563EB)
                )

                Text(
                    text = "Sign in to access your customer account",
                    fontSize = 13.sp,
                    color = Color.Gray
                )

                Spacer(modifier = Modifier.height(24.dp))
                OutlinedTextField(
                    value = email,
                    onValueChange = { email = it },
                    label = { Text("Email") },
                    leadingIcon = {
                        Image(
                            painter = painterResource(id = R.drawable.ic_person),
                            contentDescription = "Email Icon",
                            modifier = Modifier.size(20.dp)
                        )
                    },
                    shape = RoundedCornerShape(7.dp),
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Email),
                    singleLine = true,
                    modifier = Modifier
                        .fillMaxWidth()
                        .testTag("email_input"),
                    colors = OutlinedTextFieldDefaults.colors(
                        focusedBorderColor = BlueAccent,
                        unfocusedBorderColor = Color.Gray
                    )
                )

                Spacer(modifier = Modifier.height(15.dp))

                // Password field
                OutlinedTextField(
                    value = password,
                    onValueChange = { password = it },
                    label = { Text("Password") },
                    leadingIcon = {
                        Image(
                            painter = painterResource(id = R.drawable.ic_lock),
                            contentDescription = "Password Icon",
                            modifier = Modifier.size(20.dp)
                        )
                    },
                    shape = RoundedCornerShape(7.dp),
                    visualTransformation = PasswordVisualTransformation(),
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Password),
                    singleLine = true,
                    modifier = Modifier
                        .fillMaxWidth()
                        .testTag("password_input"),
                    colors = OutlinedTextFieldDefaults.colors(
                        focusedBorderColor = BlueAccent,
                        unfocusedBorderColor = Color.Gray
                    )
                )

                // Forgot Password link
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(vertical = 4.dp),
                    contentAlignment = Alignment.CenterEnd
                ) {
                    TextButton(
                        onClick = onNavigateToForgotPassword,
                        modifier = Modifier.testTag("forgot_password_button")
                    ) {
                        Text(
                            text = "Forgot Password?",
                            style = androidx.compose.ui.text.TextStyle(
                                fontSize = 14.sp,
                                fontWeight = FontWeight.Bold,
                                color = BlueAccent
                            )
                        )
                    }
                }

                Spacer(modifier = Modifier.height(12.dp))

                // Login Button
                Button(
                    onClick = { handleLogin() },
                    enabled = !isLoading,
                    shape = RoundedCornerShape(7.dp),
                    elevation = ButtonDefaults.buttonElevation(defaultElevation = 5.dp),
                    colors = ButtonDefaults.buttonColors(
                        containerColor = GrayBackground,
                        contentColor = BlueAccent
                    ),
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(52.dp)
                        .testTag("login_button")
                ) {
                    if (isLoading) {
                        CircularProgressIndicator(
                            color = BlueAccent,
                            modifier = Modifier.size(24.dp),
                            strokeWidth = 2.dp
                        )
                    } else {
                        Text(
                            text = "Login",
                            fontSize = 18.sp,
                            fontWeight = FontWeight.Bold,
                            color = BlueAccent
                        )
                    }
                }

                Spacer(modifier = Modifier.height(24.dp))

                // Divider Row with "or"
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(vertical = 8.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    HorizontalDivider(
                        modifier = Modifier.weight(1f),
                        color = Color.Black,
                        thickness = 1.dp
                    )
                    Text(
                        text = "or",
                        modifier = Modifier.padding(horizontal = 12.dp),
                        style = androidx.compose.ui.text.TextStyle(
                            fontSize = 16.sp,
                            fontWeight = FontWeight.Bold,
                            color = Color.Black
                        )
                    )
                    HorizontalDivider(
                        modifier = Modifier.weight(1f),
                        color = Color.Black,
                        thickness = 1.dp
                    )
                }

                Spacer(modifier = Modifier.height(16.dp))

                // Continue with Google Button
                Button(
                    onClick = {
                        scope.launch {
                            snackbarHostState.showSnackbar("Signing in with Google...")
                            onLoginSuccess("google.user@example.com")
                        }
                    },
                    shape = RoundedCornerShape(7.dp),
                    elevation = ButtonDefaults.buttonElevation(defaultElevation = 5.dp),
                    colors = ButtonDefaults.buttonColors(
                        containerColor = GrayBackground,
                        contentColor = BlueAccent
                    ),
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(52.dp)
                        .testTag("google_login_button")
                ) {
                    Row(
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Image(
                            painter = painterResource(id = R.drawable.ic_google),
                            contentDescription = "Google Logo",
                            modifier = Modifier.size(26.dp)
                        )
                        Spacer(modifier = Modifier.width(10.dp))
                        Text(
                            text = "Continue with Google",
                            fontSize = 17.sp,
                            fontWeight = FontWeight.Bold,
                            color = BlueAccent
                        )
                    }
                }

                Spacer(modifier = Modifier.height(30.dp))

                // Don't have an account? Sign Up
                TextButton(
                    onClick = onNavigateToSignup,
                    modifier = Modifier.testTag("signup_navigation_button")
                ) {
                    val annotatedString = buildAnnotatedString {
                        append("Don't have an account? ")
                        withStyle(
                            style = SpanStyle(
                                color = BlueAccent,
                                fontWeight = FontWeight.Bold
                            )
                        ) {
                            append("Sign Up")
                        }
                    }
                    Text(
                        text = annotatedString,
                        fontSize = 14.sp,
                        color = Color.Black
                    )
                }

                Spacer(modifier = Modifier.height(40.dp))
            }
        }
    }
}
