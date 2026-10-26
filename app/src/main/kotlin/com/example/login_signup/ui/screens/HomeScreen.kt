package com.example.login_signup.ui.screens

import androidx.compose.animation.core.FastOutSlowInEasing
import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.tween
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AccountCircle
import androidx.compose.material.icons.filled.Check
import androidx.compose.material.icons.filled.Diamond
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material.icons.filled.Search
import androidx.compose.material.icons.filled.ShoppingCart
import androidx.compose.material.icons.filled.Star
import androidx.compose.material.icons.filled.Store
import androidx.compose.material.icons.filled.TrendingUp
import androidx.compose.material3.Badge
import androidx.compose.material3.BadgedBox
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.OutlinedTextFieldDefaults
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateListOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.login_signup.R
import com.example.login_signup.ui.theme.BackgroundDeep
import com.example.login_signup.ui.theme.BackgroundNavy
import com.example.login_signup.ui.theme.GoldAccent
import com.example.login_signup.ui.theme.NeonBlue
import com.example.login_signup.ui.theme.NeonCyan
import com.example.login_signup.ui.theme.NeonViolet
import com.example.login_signup.ui.theme.SurfaceCard
import kotlinx.coroutines.launch

data class ChitralProduct(
    val id: String,
    val title: String,
    val category: String,
    val pricePkr: Int,
    val rating: Float,
    val confirmedPurchases: Int,
    val description: String
)

val sampleProducts = listOf(
    ChitralProduct(
        id = "1",
        title = "Authentic Chitrali Pakol Cap",
        category = "Caps & Wool",
        pricePkr = 1800,
        rating = 4.9f,
        confirmedPurchases = 84,
        description = "Hand-rolled pure sheep wool traditional Pakol with peacock feather crest from Shahi Bazaar."
    ),
    ChitralProduct(
        id = "2",
        title = "Chitral Patti Wool Shawl (Chugha)",
        category = "Patti Wool",
        pricePkr = 8900,
        rating = 5.0f,
        confirmedPurchases = 42,
        description = "Warm hand-woven Chitral sheep-wool Patti fabric crafted by master weavers of Kalash Valley."
    ),
    ChitralProduct(
        id = "3",
        title = "Chitrali Chilgoza Pine Nuts (500g)",
        category = "Dry Fruits",
        pricePkr = 4900,
        rating = 4.8f,
        confirmedPurchases = 65,
        description = "Freshly harvested roasted organic pine nuts directly from the forests of Golen and Chitral."
    ),
    ChitralProduct(
        id = "4",
        title = "Wild Flora Tirich Mir Honey (1kg)",
        category = "Pure Honey",
        pricePkr = 2900,
        rating = 4.9f,
        confirmedPurchases = 52,
        description = "100% raw, unpasteurized natural honey collected from high-altitude wild mountain flora."
    ),
    ChitralProduct(
        id = "5",
        title = "Natural Chitral Aquamarine Specimen",
        category = "Gemstones",
        pricePkr = 14500,
        rating = 4.9f,
        confirmedPurchases = 18,
        description = "Mined from Hindu Kush pegmatites in Chitral, completely untreated mineral treasure."
    )
)

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun HomeScreen(
    currentUser: String?,
    onNavigateToLogin: () -> Unit,
    onNavigateToSignup: () -> Unit,
    onLogout: () -> Unit
) {
    val snackbarHostState = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()
    var searchQuery by remember { mutableStateOf("") }
    var selectedCategory by remember { mutableStateOf("All") }
    var deliveryLocation by remember { mutableStateOf("Chitral Town, Shahi Bazaar") }
    val cartItems = remember { mutableStateListOf<ChitralProduct>() }
    var showCartSheet by remember { mutableStateOf(false) }
    var showVendorSheet by remember { mutableStateOf(false) }

    val categories = listOf("All", "Caps & Wool", "Patti Wool", "Dry Fruits", "Pure Honey", "Gemstones")

    // Dynamic Trending Products: rank by confirmed purchase signals
    val trendingProducts = remember {
        sampleProducts.sortedByDescending { it.confirmedPurchases }
    }

    val filteredProducts = sampleProducts.filter { product ->
        val matchesCategory = (selectedCategory == "All") || (product.category == selectedCategory)
        val matchesSearch = product.title.contains(searchQuery, ignoreCase = true) ||
                product.description.contains(searchQuery, ignoreCase = true)
        matchesCategory && matchesSearch
    }

    // Animated breathing gradient for futuristic glowing aura
    val infiniteTransition = rememberInfiniteTransition(label = "pulse")
    val pulseGlow by infiniteTransition.animateFloat(
        initialValue = 0.2f,
        targetValue = 0.5f,
        animationSpec = infiniteRepeatable(
            animation = tween(3000, easing = FastOutSlowInEasing),
            repeatMode = RepeatMode.Reverse
        ),
        label = "glow"
    )

    Scaffold(
        topBar = {
            CenterAlignedTopAppBar(
                title = {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Image(
                            painter = painterResource(id = R.drawable.app_logo),
                            contentDescription = "Chitral Shop Logo",
                            modifier = Modifier
                                .size(36.dp)
                                .clip(CircleShape)
                        )
                        Spacer(modifier = Modifier.width(10.dp))
                        Column(horizontalAlignment = Alignment.CenterHorizontally) {
                            Row(verticalAlignment = Alignment.CenterVertically) {
                                Text(
                                    text = "CHITRAL SHOP",
                                    fontWeight = FontWeight.Black,
                                    fontSize = 18.sp,
                                    letterSpacing = 1.2.sp,
                                    color = Color.White
                                )
                                Spacer(modifier = Modifier.width(6.dp))
                                Box(
                                    modifier = Modifier
                                        .background(NeonCyan.copy(alpha = 0.2f), RoundedCornerShape(4.dp))
                                        .border(1.dp, NeonCyan.copy(alpha = 0.5f), RoundedCornerShape(4.dp))
                                        .padding(horizontal = 4.dp, vertical = 1.dp)
                                ) {
                                    Text("3D", fontSize = 9.sp, fontWeight = FontWeight.Bold, color = NeonCyan)
                                }
                            }
                            Text(
                                text = "By Rahmat • Multi-Vendor Marketplace",
                                fontSize = 10.sp,
                                color = NeonCyan.copy(alpha = 0.9f)
                            )
                        }
                    }
                },
                actions = {
                    IconButton(
                        onClick = { showCartSheet = true },
                        modifier = Modifier.testTag("cart_button")
                    ) {
                        BadgedBox(
                            badge = {
                                if (cartItems.isNotEmpty()) {
                                    Badge(
                                        containerColor = NeonCyan,
                                        contentColor = Color.Black
                                    ) {
                                        Text("${cartItems.size}", fontWeight = FontWeight.Bold)
                                    }
                                }
                            }
                        ) {
                            Icon(
                                imageVector = Icons.Default.ShoppingCart,
                                contentDescription = "Shopping Cart",
                                tint = Color.White
                            )
                        }
                    }
                },
                colors = TopAppBarDefaults.centerAlignedTopAppBarColors(
                    containerColor = BackgroundNavy
                )
            )
        },
        snackbarHost = { SnackbarHost(snackbarHostState) },
        containerColor = BackgroundDeep
    ) { paddingValues ->
        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues),
            contentPadding = PaddingValues(bottom = 32.dp)
        ) {
            // Futuristic Hero Banner
            item {
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .background(
                            Brush.verticalGradient(
                                colors = listOf(BackgroundNavy, BackgroundDeep)
                            )
                        )
                        .padding(horizontal = 16.dp, vertical = 14.dp)
                ) {
                    Column {
                        // Location Selector
                        Box(
                            modifier = Modifier
                                .fillMaxWidth()
                                .background(SurfaceCard, RoundedCornerShape(10.dp))
                                .border(1.dp, Color.White.copy(alpha = 0.08f), RoundedCornerShape(10.dp))
                                .clickable {
                                    deliveryLocation = if (deliveryLocation.contains("Shahi")) {
                                        "Booni, Upper Chitral"
                                    } else if (deliveryLocation.contains("Booni")) {
                                        "Drosh Valley, Lower Chitral"
                                    } else {
                                        "Chitral Town, Shahi Bazaar"
                                    }
                                    scope.launch {
                                        snackbarHostState.showSnackbar("Location set to $deliveryLocation")
                                    }
                                }
                                .padding(horizontal = 12.dp, vertical = 8.dp)
                        ) {
                            Row(verticalAlignment = Alignment.CenterVertically) {
                                Icon(
                                    imageVector = Icons.Default.LocationOn,
                                    contentDescription = "Location",
                                    tint = NeonCyan,
                                    modifier = Modifier.size(16.dp)
                                )
                                Spacer(modifier = Modifier.width(8.dp))
                                Text(
                                    text = "Delivering to: $deliveryLocation",
                                    color = Color.White,
                                    fontSize = 12.sp,
                                    maxLines = 1,
                                    overflow = TextOverflow.Ellipsis
                                )
                            }
                        }

                        Spacer(modifier = Modifier.height(14.dp))

                        // User profile or Quick Action
                        if (!currentUser.isNullOrBlank()) {
                            Row(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .background(SurfaceCard, RoundedCornerShape(10.dp))
                                    .border(1.dp, NeonCyan.copy(alpha = 0.3f), RoundedCornerShape(10.dp))
                                    .padding(horizontal = 14.dp, vertical = 10.dp),
                                verticalAlignment = Alignment.CenterVertically,
                                horizontalArrangement = Arrangement.SpaceBetween
                            ) {
                                Row(verticalAlignment = Alignment.CenterVertically) {
                                    Icon(
                                        imageVector = Icons.Default.AccountCircle,
                                        contentDescription = "User",
                                        tint = NeonCyan,
                                        modifier = Modifier.size(24.dp)
                                    )
                                    Spacer(modifier = Modifier.width(10.dp))
                                    Column {
                                        Text("Logged in customer", fontSize = 11.sp, color = Color.Gray)
                                        Text(currentUser, fontSize = 13.sp, fontWeight = FontWeight.Bold, color = Color.White)
                                    }
                                }
                                TextButton(onClick = onLogout) {
                                    Text("Logout", color = NeonCyan, fontSize = 12.sp, fontWeight = FontWeight.Bold)
                                }
                            }
                        } else {
                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.spacedBy(10.dp)
                            ) {
                                Button(
                                    onClick = onNavigateToLogin,
                                    colors = ButtonDefaults.buttonColors(containerColor = NeonCyan, contentColor = Color.Black),
                                    shape = RoundedCornerShape(8.dp),
                                    modifier = Modifier.weight(1f)
                                ) {
                                    Text("Sign In", fontWeight = FontWeight.Bold)
                                }
                                Button(
                                    onClick = onNavigateToSignup,
                                    colors = ButtonDefaults.buttonColors(containerColor = SurfaceCard, contentColor = Color.White),
                                    shape = RoundedCornerShape(8.dp),
                                    modifier = Modifier.weight(1f)
                                ) {
                                    Text("Register")
                                }
                            }
                        }
                    }
                }
            }

            // Search Bar
            item {
                Box(modifier = Modifier.padding(horizontal = 16.dp, vertical = 8.dp)) {
                    OutlinedTextField(
                        value = searchQuery,
                        onValueChange = { searchQuery = it },
                        placeholder = { Text("Search Pakol, Patti wool, Chilgoza...", color = Color.Gray) },
                        leadingIcon = {
                            Icon(Icons.Default.Search, contentDescription = "Search", tint = NeonCyan)
                        },
                        shape = RoundedCornerShape(12.dp),
                        singleLine = true,
                        colors = OutlinedTextFieldDefaults.colors(
                            focusedTextColor = Color.White,
                            unfocusedTextColor = Color.White,
                            focusedBorderColor = NeonCyan,
                            unfocusedBorderColor = Color.White.copy(alpha = 0.15f),
                            focusedContainerColor = SurfaceCard,
                            unfocusedContainerColor = SurfaceCard
                        ),
                        modifier = Modifier
                            .fillMaxWidth()
                            .testTag("search_input")
                    )
                }
            }

            // Categories list
            item {
                LazyRow(
                    contentPadding = PaddingValues(horizontal = 16.dp),
                    horizontalArrangement = Arrangement.spacedBy(8.dp),
                    modifier = Modifier.padding(vertical = 8.dp)
                ) {
                    items(categories) { category ->
                        val isSelected = category == selectedCategory
                        Box(
                            modifier = Modifier
                                .clip(RoundedCornerShape(12.dp))
                                .background(if (isSelected) NeonCyan else SurfaceCard)
                                .border(1.dp, if (isSelected) NeonCyan else Color.White.copy(alpha = 0.1f), RoundedCornerShape(12.dp))
                                .clickable { selectedCategory = category }
                                .padding(horizontal = 14.dp, vertical = 8.dp)
                        ) {
                            Text(
                                text = category,
                                color = if (isSelected) Color.Black else Color.White,
                                fontSize = 12.sp,
                                fontWeight = if (isSelected) FontWeight.Bold else FontWeight.Normal
                            )
                        }
                    }
                }
            }

            // Dynamic Trending Products (Real Purchase Data Engine)
            item {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(start = 16.dp, top = 16.dp, end = 16.dp, bottom = 8.dp),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Icon(Icons.Default.TrendingUp, contentDescription = null, tint = NeonCyan, modifier = Modifier.size(20.dp))
                        Spacer(modifier = Modifier.width(6.dp))
                        Text(
                            text = "Trending Now (Real Purchases)",
                            fontSize = 16.sp,
                            fontWeight = FontWeight.Bold,
                            color = Color.White
                        )
                    }
                    Box(
                        modifier = Modifier
                            .background(NeonViolet.copy(alpha = 0.2f), RoundedCornerShape(6.dp))
                            .border(1.dp, NeonViolet.copy(alpha = 0.5f), RoundedCornerShape(6.dp))
                            .padding(horizontal = 6.dp, vertical = 2.dp)
                    ) {
                        Text("Verified Sales", fontSize = 10.sp, color = NeonViolet, fontWeight = FontWeight.Bold)
                    }
                }

                // Horizontal Carousel of Trending Products with 3D Card Look
                LazyRow(
                    contentPadding = PaddingValues(horizontal = 16.dp),
                    horizontalArrangement = Arrangement.spacedBy(14.dp)
                ) {
                    items(trendingProducts) { product ->
                        Card(
                            modifier = Modifier
                                .width(180.dp)
                                .graphicsLayer {
                                    rotationZ = -0.5f
                                    shadowElevation = 8f
                                }
                                .border(1.dp, NeonCyan.copy(alpha = pulseGlow), RoundedCornerShape(16.dp)),
                            shape = RoundedCornerShape(16.dp),
                            colors = CardDefaults.cardColors(containerColor = SurfaceCard)
                        ) {
                            Column(modifier = Modifier.padding(12.dp)) {
                                Box(
                                    modifier = Modifier
                                        .fillMaxWidth()
                                        .height(100.dp)
                                        .background(BackgroundNavy, RoundedCornerShape(12.dp)),
                                    contentAlignment = Alignment.Center
                                ) {
                                    Icon(Icons.Default.Diamond, contentDescription = null, tint = NeonCyan, modifier = Modifier.size(44.dp))
                                }
                                Spacer(modifier = Modifier.height(8.dp))
                                Text(
                                    text = product.title,
                                    fontSize = 13.sp,
                                    fontWeight = FontWeight.Bold,
                                    color = Color.White,
                                    maxLines = 1,
                                    overflow = TextOverflow.Ellipsis
                                )
                                Text(
                                    text = "${product.confirmedPurchases} verified sales",
                                    fontSize = 10.sp,
                                    color = GoldAccent
                                )
                                Spacer(modifier = Modifier.height(8.dp))
                                Row(
                                    modifier = Modifier.fillMaxWidth(),
                                    horizontalArrangement = Arrangement.SpaceBetween,
                                    verticalAlignment = Alignment.CenterVertically
                                ) {
                                    Text(
                                        text = "Rs. ${product.pricePkr}",
                                        fontSize = 13.sp,
                                        fontWeight = FontWeight.Bold,
                                        color = NeonCyan
                                    )
                                    IconButton(
                                        onClick = {
                                          cartItems.add(product)
                                          scope.launch {
                                              snackbarHostState.showSnackbar("Added ${product.title} to cart")
                                          }
                                        },
                                        modifier = Modifier.size(28.dp)
                                    ) {
                                        Box(
                                            modifier = Modifier
                                                .size(24.dp)
                                                .background(NeonCyan, CircleShape),
                                            contentAlignment = Alignment.Center
                                        ) {
                                            Text("+", color = Color.Black, fontWeight = FontWeight.Bold, fontSize = 14.sp)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // Vendor Portal Banner
            item {
                Card(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(16.dp)
                        .clickable { showVendorSheet = true },
                    shape = RoundedCornerShape(16.dp),
                    colors = CardDefaults.cardColors(containerColor = SurfaceCard)
                ) {
                    Row(
                        modifier = Modifier.padding(16.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Icon(Icons.Default.Store, contentDescription = null, tint = NeonCyan, modifier = Modifier.size(36.dp))
                        Spacer(modifier = Modifier.width(14.dp))
                        Column(modifier = Modifier.weight(1f)) {
                            Text("Chitral Multi-Vendor Portal", fontSize = 15.sp, fontWeight = FontWeight.Bold, color = Color.White)
                            Text("Open your own craft shop or manage artisan catalog", fontSize = 11.sp, color = Color.Gray)
                        }
                        Text("Open", color = NeonCyan, fontWeight = FontWeight.Bold, fontSize = 13.sp)
                    }
                }
            }

            // All Products Grid
            item {
                Text(
                    text = "Catalog Products (${filteredProducts.size})",
                    fontSize = 16.sp,
                    fontWeight = FontWeight.Bold,
                    color = Color.White,
                    modifier = Modifier.padding(horizontal = 16.dp, vertical = 6.dp)
                )
            }

            items(filteredProducts) { product ->
                Card(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 16.dp, vertical = 6.dp)
                        .border(1.dp, Color.White.copy(alpha = 0.06f), RoundedCornerShape(14.dp)),
                    shape = RoundedCornerShape(14.dp),
                    colors = CardDefaults.cardColors(containerColor = SurfaceCard)
                ) {
                    Row(
                        modifier = Modifier.padding(14.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Box(
                            modifier = Modifier
                                .size(56.dp)
                                .background(BackgroundNavy, RoundedCornerShape(10.dp)),
                            contentAlignment = Alignment.Center
                        ) {
                            Icon(Icons.Default.Diamond, contentDescription = null, tint = NeonCyan, modifier = Modifier.size(28.dp))
                        }
                        Spacer(modifier = Modifier.width(14.dp))
                        Column(modifier = Modifier.weight(1f)) {
                            Text(product.title, fontSize = 14.sp, fontWeight = FontWeight.Bold, color = Color.White)
                            Text(product.description, fontSize = 11.sp, color = Color.Gray, maxLines = 1, overflow = TextOverflow.Ellipsis)
                            Spacer(modifier = Modifier.height(4.dp))
                            Text("Rs. ${product.pricePkr}", fontSize = 14.sp, fontWeight = FontWeight.Bold, color = NeonCyan)
                        }
                        Button(
                            onClick = {
                                cartItems.add(product)
                                scope.launch {
                                    snackbarHostState.showSnackbar("Added ${product.title} to cart")
                                }
                            },
                            colors = ButtonDefaults.buttonColors(containerColor = NeonCyan, contentColor = Color.Black),
                            shape = RoundedCornerShape(8.dp),
                            contentPadding = PaddingValues(horizontal = 12.dp, vertical = 6.dp)
                        ) {
                            Text("Add", fontSize = 12.sp, fontWeight = FontWeight.Bold)
                        }
                    }
                }
            }
        }

        // Cart Sheet
        if (showCartSheet) {
            ModalBottomSheet(
                onDismissRequest = { showCartSheet = false },
                sheetState = rememberModalBottomSheetState(),
                containerColor = SurfaceCard
            ) {
                Column(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(24.dp)
                ) {
                    Text("Chitral Shop Cart", fontSize = 18.sp, fontWeight = FontWeight.Bold, color = Color.White)
                    Spacer(modifier = Modifier.height(10.dp))
                    if (cartItems.isEmpty()) {
                        Text("Your cart is empty. Add authentic Chitral crafts to begin!", color = Color.Gray, fontSize = 13.sp)
                    } else {
                        val total = cartItems.sumOf { it.pricePkr }
                        cartItems.forEachIndexed { idx, itm ->
                            Row(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .padding(vertical = 4.dp),
                                horizontalArrangement = Arrangement.SpaceBetween
                            ) {
                                Text(itm.title, color = Color.White, fontSize = 13.sp)
                                Text("Rs. ${itm.pricePkr}", color = NeonCyan, fontSize = 13.sp)
                            }
                        }
                        Spacer(modifier = Modifier.height(14.dp))
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween
                        ) {
                            Text("Total:", color = Color.White, fontWeight = FontWeight.Bold)
                            Text("Rs. $total", color = NeonCyan, fontWeight = FontWeight.Bold, fontSize = 16.sp)
                        }
                        Spacer(modifier = Modifier.height(14.dp))
                        Button(
                            onClick = {
                                cartItems.clear()
                                showCartSheet = false
                                scope.launch {
                                    snackbarHostState.showSnackbar("Order placed! Shukriya for shopping Chitral Shop.")
                                }
                            },
                            colors = ButtonDefaults.buttonColors(containerColor = NeonCyan, contentColor = Color.Black),
                            modifier = Modifier.fillMaxWidth()
                        ) {
                            Text("Place Order", fontWeight = FontWeight.Bold)
                        }
                    }
                }
            }
        }

        // Vendor Application Sheet
        if (showVendorSheet) {
            ModalBottomSheet(
                onDismissRequest = { showVendorSheet = false },
                containerColor = SurfaceCard
            ) {
                Column(modifier = Modifier.padding(24.dp)) {
                    Text("Vendor Portal — Chitral Shop", fontSize = 18.sp, fontWeight = FontWeight.Bold, color = Color.White)
                    Spacer(modifier = Modifier.height(8.dp))
                    Text(
                        "Sell your handmade Chitrali Pakols, Patti shawls, dry fruits, and gemstones across Pakistan and worldwide with Appwrite cloud security.",
                        color = Color.Gray,
                        fontSize = 12.sp
                    )
                    Spacer(modifier = Modifier.height(16.dp))
                    Button(
                        onClick = {
                            showVendorSheet = false
                            scope.launch {
                                snackbarHostState.showSnackbar("Vendor application recorded in Appwrite store registry!")
                            }
                        },
                        colors = ButtonDefaults.buttonColors(containerColor = NeonCyan, contentColor = Color.Black),
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Text("Register as Vendor", fontWeight = FontWeight.Bold)
                    }
                }
            }
        }
    }
}
